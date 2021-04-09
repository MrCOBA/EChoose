//
//  ChatController.swift
//  EChoose
//
//  Created by Oparin Oleg on 09.04.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import Foundation
import CoreData

class PageDefault {
    
    private var count: Int
    private var next: String?
    private var previous: String?
    
    init(count: Int, next: String? = nil, previous: String? = nil) {
        
        self.count = count
        self.next = next
        self.previous = previous
    }
    
    func nextPage() -> String? {
        
        return next
    }
}


public class MessageDefault: NSObject{
    
    var id: Int
    var text: String
    var isIncoming: Bool
    var date: Date?
    
    init(with id: Int, _ text: String, _ isIncoming: Bool = false, _ date: Date = NSDate() as Date) {
        
        self.id = id
        self.text = text
        self.isIncoming = isIncoming
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
    
    private var messagePage: PageDefault?
    private var dialogPage: PageDefault?
    
    static var shared: ChatController = {
        let instance = ChatController()
        return instance
    }()
    
    private override init() {
        
    }
    
    func initDialogs() {
        
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
        
    }
    
    func initMessages(from dialog: Int) {
        
        
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
                               let text = lastMessage["text"] as? String,
                               var serverDateStr = lastMessage["datetime"] as? String {
                                serverDateStr += " GMT+0"
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm z"
                                
                                let serverDate = formatter.date(from: serverDateStr)!
                                
                                formatter.timeZone = NSTimeZone() as TimeZone
                                let dateStr = formatter.string(from: serverDate)
                                let date = formatter.date(from: dateStr)!
                                
                                let messageDefault = MessageDefault(with: id, text, author == user1, date)
                                
                                
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
}
