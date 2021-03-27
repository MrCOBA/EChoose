//
//  GlobalManager.swift
//  EChoose
//
//  Created by Oparin Oleg on 14.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//
import UIKit
import CoreData

protocol TransferDelegate {
    
    func transferData(for key: String, with value: String)
    func transferData(to defaultService: ServiceDefault, _ field: ServiceDefaultField, with value: Any)
}
extension TransferDelegate {
    
    func transferData(for key: String, with value: String) {
        //default realizaton
    }
    
    func transferData(to defaultService: ServiceDefault, _ field: ServiceDefaultField, with value: Any) {
        //default realizaton
    }
}

protocol HTTPDelegate {
    
    func GET(url: URL?, data: Data?, withSerializer serializer: ((Any) -> Bool)?, isAuthorized: Bool, completition: (() -> Void)?)
    func PUT(url: URL?, data: Data?, withSerializer serializer: ((Any) -> Bool)?, isAuthorized: Bool, completition: (() -> Void)?)
    func POST(url: URL?, data: Data?, withSerializer serializer: ((Any) -> Bool)?, isAuthorized: Bool, completition: (() -> Void)?)
    func DELETE(url: URL?, data: Data?, withSerializer serializer: ((Any) -> Bool)?, isAuthorized: Bool, completition: (() -> Void)?)
}

class GlobalManager {
    
    var apiURL = "https://b879bb45c1aa.ngrok.io"
    var imageURL: String?
    var context: NSManagedObjectContext?
    var user: User?
    var buffer: Any?
    
    private var isPinging = false
    private var group: DispatchGroup
    private var queue: DispatchQueue
    private var tokenRefreshTimer: Timer?
    private var username: String?
    private var password: String?
    private var accessToken: String?
    private var refreshToken: String? {
        didSet {
            if let username = username, let password = password {
                let _ = createUser(username: username, password: password)
            }
            let url = URL(string: "\(apiURL)/profile/")
            GET(url: url, data: nil, withSerializer: profileSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                if let user = user, let _ = user.profile {
                    postNotification(Notification.Name(rawValue: "loginSuccess"))
                }
            })
        }
    }
    
    static var shared: GlobalManager = {
        let instance = GlobalManager()
        return instance
    }()
    
    private init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            context = appDelegate.persistentContainer.viewContext
        }
        queue = DispatchQueue(label: "COBA.Inc.EChoose.tokenRefreshQueue", qos: .userInteractive, attributes: .concurrent)
        group = DispatchGroup()
    }
    
    //MARK: - CoreData managing
    func loadData() {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        if let context = context {
            do {
                try user = context.fetch(fetchRequest).first
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func quit() {
        
        if let context = context,
           let user = user {
           
            context.delete(user)
            self.user = nil
            saveData()
        }
    }
    
    func deleteAllData(_ entity: String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        if let context = context {
            do {
                let results = try context.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    context.delete(objectData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveData() {
        
        if let context = context {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUser() {
        
        if let context = context {
            
            user = User(context: context)
            user?.username = username
            user?.password = password
            
            let url = URL(string: "\(apiURL)/profile/")
            GET(url: url, data: nil, withSerializer: profileSerializer(_:), isAuthorized: true, completition: nil)
        }
    }
    
    func createUser(username: String, password: String) -> User? {
        
        if let context = context {
            
            loadData()
            
            if let curUser = user {
                context.delete(curUser)
            }
            
            user = User(context: context)
            user?.username = username
            user?.password = password
            saveData()
        }
        return user
    }
    
    func dateToAge(date: Date) -> Int{
        
        let calendar = Calendar.current
        let age = calendar.dateComponents([.year], from: date, to: Date()).year
        
        return age ?? 0
    }
    
    func dateToAge(date: String) -> Int{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: date) {
            
            let calendar = Calendar.current
            let age = calendar.dateComponents([.year], from: date, to: Date()).year
            
            return age ?? 0
        }
        
        return 0
    }
    
    //MARK: - Token managing
    func initRefresh() {
        isPinging = true
        guard let url = URL(string: "\(apiURL)/api/token/refresh/") else {
            return
        }
        if let refreshToken = refreshToken {
            
            let jsonObject = ["refresh" : refreshToken]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
                return
            }
            
            POST(url: url, data: jsonData, withSerializer: accessTokenSerializer(_:), isAuthorized: true, completition: {[unowned self] in
                if isPinging {
                    queue.asyncAfter(deadline: .now() + 240) {[unowned self] in
                        initRefresh()
                    }
                }
            })
        }
        
    }
    
    func deinitRefresh() {
        isPinging = false
    }
    
    func tokenInit(username: String, password: String) {
        
        guard let url = URL(string: "\(apiURL)/api/token/") else {
            return
        }
        
        let jsonObject = ["username" : username, "password" : password]
        
        self.username = username
        self.password = password
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
            return
        }
        
        POST(url: url, data: jsonData, withSerializer: tokenSerializer(_:), isAuthorized: false, completition: nil)
    }
    
    func tokenInit() {
        
        guard let url = URL(string: "\(apiURL)/api/token/") else {
            return
        }
        
        if let user = user, let username = user.username, let password = user.password {
            
            let jsonObject = ["username" : username, "password" : password]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
                return
            }
            print(jsonData)
            POST(url: url, data: jsonData, withSerializer: tokenSerializer(_:), isAuthorized: false, completition: nil)
            
        } else {
            postNotification(Notification.Name("loginUnsuccess"))
        }
    }
}
extension GlobalManager: HTTPDelegate {
    
    //MARK: - GET Request
    func GET(url: URL?, data: Data?, withSerializer serializer: ((Any) -> Bool)?, isAuthorized: Bool, completition: (() -> Void)?) {
        
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if isAuthorized {
            request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
        if let data = data {
            request.httpBody = data
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data, let serializer = serializer {
                print(serializer(data))
            }
            
            if let completition = completition {
                completition()
            }
        }
        task.resume()
    }
    
    //MARK: - POST Request
    func POST(url: URL?, data: Data?, withSerializer serializer: ((Any) -> Bool)?, isAuthorized: Bool, completition: (() -> Void)?) {
    
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if isAuthorized {
            request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
        if let data = data {
            request.httpBody = data
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
            if let error = error {
                print("Error took place \(error)")
                return
            }
        
            if let data = data, let serializer = serializer {
                print(serializer(data))
            }
            
            if let completition = completition {
                completition()
            }
        }
        task.resume()
    }
    
    private func GETimage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completition: (() -> Void)?) {
        
        GETimage(from: url) {[unowned self] (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            if let data = data {
                buffer = UIImage(data: data)
            }
            
            if let completition = completition {
                completition()
            }
        }
    }
    
    func POSTimage(url: URL?, image: UIImage?,  withSerializer serializer: ((Any) -> Bool)?, completition: (() -> Void)?) {
        
        var request  = URLRequest(url: URL(string: "\(apiURL)/profile/upload_image/")!)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = createBody(parameters: [:],
                                boundary: boundary,
                                data: image?.jpegData(compressionQuality: 0.7)! ?? UIImage(named: "noimage")!.jpegData(compressionQuality: 0.7)! ,
                                mimeType: "image/jpg",
                                fileName: "avatarImage.jpg")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
            if let error = error {
                print("Error took place \(error)")
                return
            }
        
            if let data = data, let serializer = serializer {
                print(serializer(data))
            }
            
            if let completition = completition {
                completition()
            }
        }
        task.resume()
    }
    
    private func createBody(parameters: [String: String], boundary: String, data: Data, mimeType: String, fileName: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    //MARK: - PUT Request
    func PUT(url: URL?, data: Data?, withSerializer serializer: ((Any) -> Bool)?, isAuthorized: Bool, completition: (() -> Void)?) {
        
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if isAuthorized {
            request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
        if let data = data {
            request.httpBody = data
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
            if let error = error {
                print("Error took place \(error)")
                return
            }

            if let data = data, let serializer = serializer {
                print(serializer(data))
            }
            
            if let completition = completition {
                completition()
            }
        }
        task.resume()
    }
    //MARK: - DELETE Request
    func DELETE(url: URL?, data: Data?, withSerializer serializer: ((Any) -> Bool)?, isAuthorized: Bool, completition: (() -> Void)?) {
        
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if isAuthorized {
            request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
        if let data = data {
            request.httpBody = data
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                
            if let error = error {
                print("Error took place \(error)")
                return
            }
        
            if let data = data, let serializer = serializer {
                print(serializer(data))
            }
            
            if let completition = completition {
                completition()
            }
        }
        task.resume()
    }
}
//MARK: - Serializers
extension GlobalManager {
    
    func perform(data: Any, isArray: Bool = false) -> Any? {
        
        guard let data = data as? Data else {
            return nil
        }
        
        let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if isArray {
            
            guard let json = jsonResponse as? [[String : Any]] else {
                return nil
            }
            return json
        }
        guard let json = jsonResponse as? [String : Any] else {
            return nil
        }
        
        return json
    }
    
    //Profile parser
    func profileSerializer(_ data: Any) -> Bool {
        
        guard let json = perform(data: data) as? [String : Any] else {
            return false
        }
        
        guard let user = user, let context = context else {
            return false
        }
        
        if let profile = user.profile {
            context.delete(profile)
        }
        
        let profile = Profile(context: context)
        
        if let id = json["id"] as? Int32 {
            profile.id = id
        }
        
        if let userData = json["user"] as? [String : Any] {
            
            let firstname = userData["first_name"] as? String
            let lastname = userData["last_name"] as? String
            let email = userData["email"] as? String
            
            profile.firstname = firstname
            profile.lastname = lastname
            profile.email = email
        }
        
        if let isMale = json["isMale"] as? Bool{
            profile.sex = isMale
        }
        
        if let description = json["description"] as? String {
            profile.descript = description
        }
        
        if let birthDate = json["birth_date"] as? String{
            profile.age = Int32(dateToAge(date: birthDate))
        }
        
        if let image = json["image"] as? String {
            imageURL = image
        } else {
            imageURL = nil
        }
        
        user.profile = profile
        
        saveData()
        return true
    }
    
    //Dialog parser
    func dialogSerializer(_ data: Any) -> Bool {
        return true
    }
    
    //Message parser
    func messageSerializer(_ data: Any) -> Bool {
        return true
    }
    
    //Location parser
    func locationSerializer(_ data: Any) -> Bool {
        
        guard let json = perform(data: data, isArray: false) as? [String : Any] else {
            return false
        }
        
        guard let user = user, let context = context, let profile = user.profile else {
            return false
        }
        
        if let id = json["id"] as? Int32,
           let name = json["name"] as? String,
           let latitude = json["latitude"] as? Double,
           let longitude = json["longitude"] as? Double{
            
            let location = Location(context: context)
            location.id = id
            location.name = name
            location.latitude = latitude
            location.longitude = longitude
            profile.addToLocations(location)
        }
        saveData()
        return true
    }
    
    //Locations parser
    func locationsSerializer(_ data: Any) -> Bool {
        
        deleteAllData("Location")
        guard let jsonArray = perform(data: data, isArray: true) as? [[String : Any]] else {
            return false
        }
        
        guard let user = user, let context = context, let profile = user.profile else {
            return false
        }
        
        for json in jsonArray {
            
            if let id = json["id"] as? Int32,
               let name = json["name"] as? String,
               let latitude = json["latitude"] as? Double,
               let longitude = json["longitude"] as? Double {
                
                let location = Location(context: context)
                location.id = id
                location.name = name
                location.latitude = latitude
                location.longitude = longitude
                profile.addToLocations(location)
            }
        }
        saveData()
        return true
    }
    
    //Services parser
    func servicesSerializer(_ data: Any) -> Bool {
        
        deleteAllData("Service")
        
        guard let jsonArray = perform(data: data, isArray: true) as? [[String : Any]] else {
            return false
        }
        
        guard let user = user, let context = context, let profile = user.profile, let locations = profile.locations else {
            return false
        }
        
        for json in jsonArray {
            
            
            if let id = json["id"] as? Int32,
               let edLocation = json["location"] as? String,
               let categoryid = json["category"] as? Int32,
               let description = json["description"] as? String,
               let price = json["price"] as? Int32,
               let isTutor = json["isTutor"] as? Bool,
               let types = json["types"] as? [Int],
               let isActive = json["isActive"] as? Bool {
               
                let service = Service(context: context)
                
                if let addressid = json["address"] as? Int {
                    var location: Location?
                    
                    for i in 0..<locations.count {
                        
                        guard let curLocation = locations[i] as? Location else {
                            return false
                        }
                        
                        if curLocation.id == addressid {
                            location = curLocation
                            break
                        }
                    }
                    
                    if let nnLocation = location {
                        service.location = nnLocation
                    }
                }

                service.edLocationType = edLocation
                service.id = id
                service.serviceTypes = types
                service.isActive = isActive
                service.category = categoryid
                service.descript = description
                service.price = price
                service.isTutor = isTutor
                
                profile.addToServices(service)
            }
        }
        
        saveData()
        return true
    }
    
    //Service parser
    func serviceSerializer(_ data: Any) -> Bool {
        
        guard let json = perform(data: data, isArray: false) as? [String : Any] else {
            return false
        }
        
        guard let user = user, let context = context, let profile = user.profile, let locations = profile.locations else {
            return false
        }
        
        if let id = json["id"] as? Int32,
           let edLocation = json["location"] as? String,
           let categoryid = json["category"] as? Int32,
           let description = json["description"] as? String,
           let price = json["price"] as? Int32,
           let isTutor = json["isTutor"] as? Bool,
           let types = json["types"] as? [Int],
           let isActive = json["isActive"] as? Bool {
            
            
            let service = Service(context: context)
            
            if let addressid = json["address"] as? Int {
                var location: Location?
                
                for i in 0..<locations.count {
                    
                    guard let curLocation = locations[i] as? Location else {
                        return false
                    }
                    
                    if curLocation.id == addressid {
                        location = curLocation
                        break
                    }
                }
                
                if let nnLocation = location {
                    service.location = nnLocation
                }
            }
            
            service.edLocationType = edLocation
            service.id = id
            service.serviceTypes = types
            service.isActive = isActive
            service.category = categoryid
            service.descript = description
            service.price = price
            service.isTutor = isTutor
            
            profile.addToServices(service)
        }
        
        return true
    }
    
    //Access and refresh token parser
    func tokenSerializer(_ data: Any) -> Bool {
        
        guard let json = perform(data: data) as? [String : Any] else {
            postNotification(Notification.Name("loginUnsuccess"))
            return false
        }
        
        if let accessToken = json["access"] as? String, let refreshToken = json["refresh"] as? String {
            
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            
        } else {
            
            self.username = ""
            self.password = ""
            postNotification(Notification.Name("loginUnsuccess"))
            return false
        }
        
        return true
    }
    
    //Access token parser
    func accessTokenSerializer(_ data: Any) -> Bool {
        
        guard let json = perform(data: data) as? [String : Any] else {
            postNotification(Notification.Name("loginUnsuccess"))
            return false
        }
        
        if let accessToken = json["access"] as? String {
            
            self.accessToken = accessToken
            
        } else {
            postNotification(Notification.Name("loginUnsuccess"))
            return false
        }
        
        return true
    }
}
//MARK: - Notifications
extension GlobalManager {
 
    func postNotification(_ name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: nil)
    }
    
    func postNotification(_ name: Notification.Name, userInfo: [String : Any]) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
}
//MARK: - JSON fromatters
extension GlobalManager {
    
    func registrationJSON(from data: [String : String]) -> Data? {
        
        let jsonObject: [String : Any] = [
            "credentials" : [
                "username" : data["username"],
                "password" : data["password"],
                "first_name" : data["firstname"],
                "last_name" : data["lastname"],
                "description" : data["description"],
                "email" : data["email"]],
            "isMale" : data["isMale"] ?? "False",
            "birth_date" : data["birthDate"] ?? ""
        ]
        
        let valid = JSONSerialization.isValidJSONObject(jsonObject)
        
        if valid {
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return jsonData
        }
        
        return nil
    }
    
    func serviceJSON(from data: ServiceDefault) -> Data? {
        
        var jsonObject: [String : Any] = [
            "location" : data.edLocation,
            "category_id" : data.categoryid,
            "description" : data.description,
            "price" : data.price,
            "isTutor" : data.isTutor,
            "types" : data.types,
            "isActive" : data.isActive
        ]
        
        if data.addressid >= 0 {
            jsonObject["address_id"] = data.addressid
        }
        let valid = JSONSerialization.isValidJSONObject(jsonObject)
        
        if valid {
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
            print(jsonObject)
            return jsonData
        }
        
        return nil
    }
    
    func filterJSON(from filter: Filter) -> Data? {
        
        let jsonObject: [String : Any]  = [
            
            "findTutor" : filter.findTutor,
            "min_price" : filter.minPrice,
            "max_price" : filter.maxPrice,
            "distance" : filter.distance
        ]
        
        let valid = JSONSerialization.isValidJSONObject(jsonObject)
        
        if valid {
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
            print(jsonObject)
            return jsonData
        }
        
        return nil
    }
    
    func reactJSON(from filter: Filter, status: String) -> Data? {
        
        let jsonObject: [String : Any]  = [
            
            "status" : status,
            "findTutor" : filter.findTutor,
            "min_price" : filter.minPrice,
            "max_price" : filter.maxPrice,
            "distance" : filter.distance
        ]
        
        let valid = JSONSerialization.isValidJSONObject(jsonObject)
        
        if valid {
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
            print(jsonObject)
            return jsonData
        }
        
        return nil
    }
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
