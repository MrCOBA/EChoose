//
//  ChatController.swift
//  EChoose
//
//  Created by Oparin Oleg on 09.04.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PageDefault {
    
    private var count: Int
    private var next: String?
    private var previous: String?
    
    init(count: Int, next: String? = nil, previous: String? = nil) {
        
        self.count = count
        
        if let next = next {
            
            if !next.contains("https") {
                
                self.next = next.replacingOccurrences(of: "http", with: "https")
            }
        }
        
        if let previous = previous {
            
            if !previous.contains("https") {
                
                self.previous = previous.replacingOccurrences(of: "http", with: "https")
            }
        }
    }
    
    func nextPage() -> String? {
        return next
    }
}


public class MessageDefault: NSObject, NSCoding{
    
    var id: Int
    var dialog: Int
    var text: String
    var isIncoming: Bool
    var date: Date
    
    init(with id: Int, from dialog: Int, _ text: String, _ isIncoming: Bool = false, _ date: Date) {
        
        self.id = id
        self.text = text
        self.dialog = dialog
        self.isIncoming = isIncoming
        self.date = date
    }
    
    public required init?(coder: NSCoder) {
        id = coder.decodeInteger(forKey: "id")
        text = coder.decodeObject(forKey: "text") as! String
        dialog = coder.decodeInteger(forKey: "dialog")
        isIncoming = coder.decodeBool(forKey: "isIncoming")
        date = coder.decodeObject(forKey: "date") as! Date
    }
    
    public func encode(with coder: NSCoder) {
        
        coder.encode(id, forKey: "id")
        coder.encode(text, forKey: "text")
        coder.encode(dialog, forKey: "dialog")
        coder.encode(isIncoming, forKey: "isIncoming")
        coder.encode(date, forKey: "date")
    }
}

class DialogDefault {
    
    var id: Int
    var user1: Int
    var user2: Int
    
    var userDefault: UserDefault?
    var lastMessage: MessageDefault?
    var messages: [MessageDefault] = []
    
    init(with id: Int, between user1: Int, _ user2: Int) {
        
        self.id = id
        self.user1 = user1
        self.user2 = user2
    }
    
}

class ChatController: SequenceIterator {
    
    var dialogs: [DialogDefault] = []
    var selectedDialog: Int = 0
    
    private var isPinging = false
    private var queue: DispatchQueue
    private var messagePage: PageDefault?
    private var dialogPage: PageDefault?
    
    static var shared: ChatController = {
        let instance = ChatController()
        return instance
    }()
    
    private override init() {
        
        queue = DispatchQueue(label: "COBA.Inc.EChoose.checkMessegesQueue", qos: .userInteractive, attributes: .concurrent)
    }
    
    func startDialog(with receiverId: Int) {
        
        globalManager.deleteAllData("Dialog")
        dialogs = []
        usersDefault = []
        
        guard let jsonData = globalManager.dialogJSON(with: receiverId) else {
            return
        }
        
        guard let url = URL(string: "\(globalManager.apiURL)/dialog/") else {
            return
        }
        
        globalManager.POST(url: url, data: jsonData, withSerializer: dialogSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            if dialogs.count > 0 {
                
                if let url = URL(string: "\(globalManager.apiURL)/profile/\(dialogs[0].user2)/") {
                    
                    globalManager.GET(url: url, data: nil, withSerializer: userSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                        
                        dialogs[0].userDefault = usersDefault[0]
                        
                        guard let url = URL(string: "\(globalManager.apiURL)/\(usersDefault[0].imageURL)/") else {
                            globalManager.postNotification(Notification.Name("dialogLoaded"))
                            return
                        }
                        
                        globalManager.downloadImage(from: url, completition: { [unowned self] in
                            
                            if let image = globalManager.buffer as? UIImage {
                                usersDefault[0].image = image
                            }
                            
                            globalManager.postNotification(Notification.Name("dialogLoaded"))
                        })
                    })
                }
                
                
            }
        })
    }
    
    func initDialogs() {
        
        globalManager.deleteAllData("Dialog")
        dialogs = []
        usersDefault = []
        
        guard let url = URL(string: "\(globalManager.apiURL)/dialog/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: dialogPartSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            if dialogs.count > 0 {
                iterativeUsersInit(maxIter: dialogs.count, iter: 0)
            }
        })
        
    }
    
    func updateDialogs() {
        
        let startIter = dialogs.count
        
        if let next = dialogPage?.nextPage() {
            
            guard let url = URL(string: next) else {
                return
            }
            
            globalManager.GET(url: url, data: nil, withSerializer: dialogPartSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                if dialogs.count > startIter {
                    iterativeUsersInit(maxIter: dialogs.count, iter: startIter)
                }
            })
        }
    }
    
    func initMessages(from dialog: Int) {
        
        isPinging = true
        selectedDialog = dialog
        
        dialogs[dialog].messages = []
        
        guard let id = index2id(dialog) else {
            return
        }
        
        guard let url = URL(string: "\(globalManager.apiURL)/dialog/\(id)/messages/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: messagePartSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            initCheckMessages(in: dialog)
            globalManager.postNotification(Notification.Name("dataUpdated"))
        })
    }
    
    func updateMessages(from dialog: Int) {
        
        selectedDialog = dialog
        
        if let next = messagePage?.nextPage() {
            
            guard let url = URL(string: next) else {
                return
            }
            
            globalManager.GET(url: url, data: nil, withSerializer: messagePartSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                
                globalManager.postNotification(Notification.Name("dataUpdated"))
            })
        } else {
            globalManager.postNotification(Notification.Name("dataUpdated"))
        }
    }
    
    func sendMessage(with text: String, to dialog: Int) {
        
        guard let jsonData = globalManager.messageJSON(with: text) else {
            return
        }
        
        guard let id = index2id(dialog) else {
            return
        }
        
        guard let url = URL(string: "\(globalManager.apiURL)/dialog/\(id)/messages/") else {
            return
        }
        
        globalManager.POST(url: url, data: jsonData, withSerializer: messageSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            globalManager.postNotification(Notification.Name("dataUpdated"))
        })
    }
    
    func initCheckMessages(in dialog: Int) {
        
        guard let id = index2id(dialog) else {
            return
        }
        
        guard let url = URL(string: "\(globalManager.apiURL)/dialog/\(id)/unread_messages/") else {
            return
        }
        
        if isPinging {
            globalManager.GET(url: url, data: nil, withSerializer: newMessagesSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                
                globalManager.postNotification(Notification.Name("newMessages"))
                queue.asyncAfter(deadline: .now() + 0.5) {[unowned self] in
                    initCheckMessages(in: dialog)
                }
            })
        }

    }
    
    func deinitCheckMessages() {
        
        isPinging = false
        
    }
    
    func id2index(_ id: Int) -> Int? {
        
        for i in 0..<dialogs.count {
            
            if dialogs[i].id == id {
                return i
            }
        }
        
        return nil
    }
    
    func index2id(_ index: Int) -> Int? {
        
        if index < dialogs.count && index >= 0 {
            
            return dialogs[index].id
        }
        
        return nil
    }
    
    override func iterativeUsersInit(maxIter: Int, iter: Int){
        
        if let url = URL(string: "\(globalManager.apiURL)/profile/\(dialogs[iter].user2)/") {
            
            globalManager.GET(url: url, data: nil, withSerializer: userSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                
                if iter < usersDefault.count {
                    dialogs[iter].userDefault = usersDefault[iter]
                }
                
                nextIterate(with: iterativeUsersInit, for: iter, maxIter, completition: {
                    
                    iterativeImagesInit(maxIter: dialogs.count, iter: 0)
                })
            })
        } else {
            
            nextIterate(with: iterativeUsersInit, for: iter, maxIter, completition: {[unowned self] in
                
                iterativeImagesInit(maxIter: dialogs.count, iter: 0)
            })
        }
    }
}
extension ChatController {
    
    func dialogSerializer(_ data: Any) -> Bool {
    
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        guard let context = globalManager.context,
              let user = globalManager.user,
              let profile = user.profile else {
            return false
        }
        
        if let id = json["id"] as? Int,
           let user1 = json["user1"] as? Int,
           let user2 = json["user2"] as? Int {
            
            let dialogDefault: DialogDefault = DialogDefault(with: id, between: user1, user2)
            dialogs.append(dialogDefault)
            
            if let lastMessage = json["last_message"] as? [String : Any] {
                
                if let id = lastMessage["id"] as? Int,
                   let author = lastMessage["author"] as? Int,
                   let dialog = lastMessage["dialog"] as? Int,
                   let text = lastMessage["text"] as? String,
                   var serverDateStr = lastMessage["datetime"] as? String {
                    serverDateStr += " GMT+0"
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm z"
                    
                    let serverDate = formatter.date(from: serverDateStr)!
                    
                    formatter.timeZone = NSTimeZone() as TimeZone
                    let dateStr = formatter.string(from: serverDate)
                    let date = formatter.date(from: dateStr)!
                    
                    let messageDefault = MessageDefault(with: id, from: dialog, text, author == user2, date)
                    
                    dialogDefault.lastMessage = messageDefault
                }
            }
            
            let dialog = Dialog(context: context)
            dialog.id = Int32(id)
            dialog.user1 = Int32(user1)
            dialog.user2 = Int32(user2)
            dialog.lastMessage = dialogDefault.lastMessage
            
            profile.addToDialogs(dialog)
        }
        
        return true
    }
    
    func dialogPartSerializer(_ data: Any) -> Bool{
        
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        guard let context = globalManager.context,
              let user = globalManager.user,
              let profile = user.profile else {
            return false
        }
        
        if let count = json["count"] as? Int {
            
            dialogPage = PageDefault(count: count,
                                     next: json["next"] as? String,
                                     previous: json["previous"] as? String)
            
            if let results = json["results"] as? [[String : Any]] {
                
                for result in results {
                    
                    if let id = result["id"] as? Int,
                       let user1 = result["user1"] as? Int,
                       let user2 = result["user2"] as? Int {
                        
                        let dialogDefault: DialogDefault = DialogDefault(with: id, between: user1, user2)
                        dialogs.append(dialogDefault)
                        
                        if let lastMessage = result["last_message"] as? [String : Any] {
                            
                            if let id = lastMessage["id"] as? Int,
                               let author = lastMessage["author"] as? Int,
                               let dialog = lastMessage["dialog"] as? Int,
                               let text = lastMessage["text"] as? String,
                               var serverDateStr = lastMessage["datetime"] as? String {
                                serverDateStr += " GMT+0"
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm z"
                                
                                let serverDate = formatter.date(from: serverDateStr)!
                                
                                formatter.timeZone = NSTimeZone() as TimeZone
                                let dateStr = formatter.string(from: serverDate)
                                let date = formatter.date(from: dateStr)!
                                
                                let messageDefault = MessageDefault(with: id, from: dialog, text, author == user2, date)
                                
                                dialogDefault.lastMessage = messageDefault
                            }
                        }
                        
                        let dialog = Dialog(context: context)
                        dialog.id = Int32(id)
                        dialog.user1 = Int32(user1)
                        dialog.user2 = Int32(user2)
                        dialog.lastMessage = dialogDefault.lastMessage
                        
                        profile.addToDialogs(dialog)
                    }
                    
                }
            }
        }
        
        return true
    }
    
    func messagePartSerializer(_ data: Any) -> Bool {
        
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        guard let user = globalManager.user,
              let profile = user.profile else {
            return false
        }
        
        if let count = json["count"] as? Int {
            
            messagePage = PageDefault(count: count,
                                     next: json["next"] as? String,
                                     previous: json["previous"] as? String)
            
            if let results = json["results"] as? [[String : Any]] {
                
                for result in results {
                    
                    if let id = result["id"] as? Int,
                       let author = result["author"] as? Int,
                       let dialog = result["dialog"] as? Int,
                       let text = result["text"] as? String,
                       var serverDateStr = result["datetime"] as? String {
                        serverDateStr += " GMT+0"
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm z"
                        
                        let serverDate = formatter.date(from: serverDateStr)!
                        
                        formatter.timeZone = NSTimeZone() as TimeZone
                        let dateStr = formatter.string(from: serverDate)
                        let date = formatter.date(from: dateStr)!
                        
                        let messageDefault = MessageDefault(with: id, from: dialog, text, author != profile.id, date)
                        
                        
                        dialogs[selectedDialog].messages.insert(messageDefault, at: 0)
                        
                        if let dialog = profile.dialogs?[selectedDialog] as? Dialog{
                            
                            dialog.messages?.insert(messageDefault, at: 0)
                        }
                    }
                }
            }
            
            globalManager.saveData()
        }
        
        return true
    }
    
    func messageSerializer(_ data: Any) -> Bool {
        
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        guard let user = globalManager.user,
              let profile = user.profile else {
            return false
        }
        
        if let id = json["id"] as? Int,
           let author = json["author"] as? Int,
           let dialog = json["dialog"] as? Int,
           let text = json["text"] as? String,
           var serverDateStr = json["datetime"] as? String {
            serverDateStr += " GMT+0"
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm z"
            
            let serverDate = formatter.date(from: serverDateStr)!
            
            formatter.timeZone = NSTimeZone() as TimeZone
            let dateStr = formatter.string(from: serverDate)
            let date = formatter.date(from: dateStr)!
            
            let messageDefault = MessageDefault(with: id, from: dialog, text, author != profile.id, date)
            
            
            dialogs[selectedDialog].messages.append(messageDefault)
            
            if let dialog = profile.dialogs?[selectedDialog] as? Dialog{
                
                dialog.messages?.append(messageDefault)
                globalManager.saveData()
            }
        }
        
        return true
    }
    
    func newMessagesSerializer(_ data: Any) -> Bool {
        
        guard let jsonArray = globalManager.perform(data: data, isArray: true) as? [[String : Any]] else {
            return false
        }
        
        guard let user = globalManager.user,
              let profile = user.profile else {
            return false
        }
        
        if jsonArray.count > 0 {
            
            for i in jsonArray.count - 1...0 {
                let json = jsonArray[i]
                
                if let id = json["id"] as? Int,
                   let author = json["author"] as? Int,
                   let dialog = json["dialog"] as? Int,
                   let text = json["text"] as? String,
                   var serverDateStr = json["datetime"] as? String {
                    serverDateStr += " GMT+0"
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm z"
                    
                    let serverDate = formatter.date(from: serverDateStr)!
                    
                    formatter.timeZone = NSTimeZone() as TimeZone
                    let dateStr = formatter.string(from: serverDate)
                    let date = formatter.date(from: dateStr)!
                    
                    let messageDefault = MessageDefault(with: id, from: dialog, text, author != profile.id, date)
                    
                    
                    dialogs[selectedDialog].messages.append(messageDefault)
                    
                    if let dialog = profile.dialogs?[selectedDialog] as? Dialog{
                        
                        dialog.messages?.append(messageDefault)
                        globalManager.saveData()
                    }
                }
            }
        }
        return true
    }
}
