//
//  RegistrationViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 30.07.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit
import CoreData

protocol ImageDelegate {
    
    func setImage(_ image: UIImage)
}

struct RegistrationSectionsSizes {
    
    static var firstSection: Int = 3
    static var secondSection: Int = 4
    static var thirdSection: Int = 4
}

class RegistrationViewController:UIViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var registrationTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    let loadingVC: LoadingViewController = LoadingViewController()
    
    private var image: UIImage?
    var delegate: ImageDelegate?
    var imagePicker = UIImagePickerController()
    var globalManager: GlobalManager = GlobalManager.shared
    var data: [String : String] = ["username" : "",
                                   "password" : "",
                                   "rpassword" : "",
                                   "firstname" : "",
                                   "lastname" : "",
                                   "description" : "",
                                   "birthDate" : "",
                                   "isMale" : "",
                                   "email" : ""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        registrationTableView.delegate = self
        registrationTableView.dataSource = self
        
        //First cell type
        registrationTableView.register(UINib(nibName: TextFieldTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        //Second cell type
        registrationTableView.register(UINib(nibName: PickerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PickerTableViewCell.identifier)
        //Fourth cell type
        registrationTableView.register(UINib(nibName: DatePickerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        //Fifth cell type
        registrationTableView.register(UINib(nibName: TextViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TextViewTableViewCell.identifier)
        //Sixth cell type
        registrationTableView.register(UINib(nibName: DoublePickerCell.identifier, bundle: nil), forCellReuseIdentifier: DoublePickerCell.identifier)
        //Seventh cell type
        registrationTableView.register(UINib(nibName: ButtonTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        //Eighth cell type
        registrationTableView.register(UINib(nibName: ImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageTableViewCell.identifier)
        //Nineth cell type
        registrationTableView.register(UINib(nibName: RadioButtonsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RadioButtonsTableViewCell.identifier)
        //Header
        registrationTableView.register(UINib(nibName: SectionHeader.identifier, bundle: nil), forCellReuseIdentifier: SectionHeader.identifier)
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        globalManager.loadData()
    }
    //MARK: - Setting up UI
    func setUI(){
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.overrideUserInterfaceStyle = .light
        
        registrationTableView.layer.cornerRadius = 20
        registrationTableView.separatorStyle = .none
    }
    
    func subscribe(forNotification name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationHandler(_:)), name: name, object: nil)
    }
    
    func unsubscribe(fromNotification name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    @objc func notificationHandler(_ notification: Notification) {
        if notification.name.rawValue == "loginSuccess" {
            
            DispatchQueue.main.async {[unowned self] in
                unsubscribe(fromNotification: Notification.Name("loginSuccess"))
                unsubscribe(fromNotification: Notification.Name("loginUnsuccess"))
                globalManager.initRefresh()
                
                guard let url = URL(string: "\(globalManager.apiURL)/profile/upload_image/") else {
                    return
                }
                
                globalManager.POSTimage(url: url, image: image, withSerializer: globalManager.profileSerializer(_:), completition: {
                    
                    DispatchQueue.main.async {[unowned self] in
                        hideContentController(content: loadingVC)
                        performSegue(withIdentifier: "mainScreenSegue", sender: nil)
                    }
                })
            }
        } else if notification.name.rawValue == "loginUnsuccess"{
            
            DispatchQueue.main.async {[unowned self] in
                
                hideContentController(content: loadingVC)
            }
        } else if notification.name.rawValue == "UsernameExists" {
            
            DispatchQueue.main.async {[unowned self] in
                
                let generator = AlertGenerator()
                let alert = generator.getAlert()
                
                if let controller = alert[.existsUsername] {
                    
                    present(controller, animated: true, completion: nil)
                }
            }
        } else if notification.name.rawValue == "EmailExists" {
            
            DispatchQueue.main.async {[unowned self] in
                
                let generator = AlertGenerator()
                let alert = generator.getAlert()
                
                if let controller = alert[.existsEmail] {
                    
                    present(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mainScreenSegue" {
            let destination = segue.destination as! UITabBarController
            
            destination.selectedIndex = 2
            destination.navigationController?.setNavigationBarHidden(true, animated: true)
            
        }
    }
    
    func checkForm() -> Bool {
        let alertGenerator = AlertGenerator()
        let alert = alertGenerator.getAlert()
        
        for formElement in data {
            
            if formElement.key != "description" && formElement.value == "" {
                
                if let controller = alert[.fillAllGaps] {
                    
                    present(controller, animated: true, completion: nil)
                    return false
                }
            }
        }
        
        if data["password"] != data["rpassword"] {
            
            if let controller = alert[.notSimilarPasswords] {
                
                present(controller, animated: true, completion: nil)
                return false
            }
        }
        
        let usernameRegEx = "[A-Z0-9a-z]{6,}"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        
        if !usernamePred.evaluate(with: data["username"]) {
            if let controller = alert[.incorrectUsernameFormat] {
                
                present(controller, animated: true, completion: nil)
                return false
            }
        }
        
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        if !passwordPred.evaluate(with: data["password"]) {
            if let controller = alert[.incorrectPasswordFormat] {
                
                present(controller, animated: true, completion: nil)
                return false
            }
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailPred.evaluate(with: data["email"]) {
            if let controller = alert[.incorrectEmailFormat] {
                
                present(controller, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
    
    func displayContentController(content: UIViewController) {
        self.navigationController?.addChild(content)
        self.navigationController?.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
    //MARK: - Actions
    @IBAction func backSwipeHandler(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
//MARK: - TableView Extension
extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return RegistrationSectionsSizes.firstSection
            case 1:
                return RegistrationSectionsSizes.secondSection
            case 2:
                return RegistrationSectionsSizes.thirdSection
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
            case 0:
                
                switch indexPath.row {
                    
                    case 0:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                        cell.delegate = self
                        cell.setCell("Username", false, "Username...", .default, ("username", data["username"] ?? ""))
                        return cell
                        
                    case 1:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                        cell.delegate = self
                        cell.setCell("Password", true, "Password...", .default, ("password", data["password"] ?? ""))
                        return cell
                        
                    case 2:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                        cell.delegate = self
                        cell.setCell("Repeat password", true, "Password again...", .default, ("rpassword", data["rpassword"] ?? ""))
                        return cell
                        
                    default:
                        return UITableViewCell()
                }
                
            case 1:
                
                switch indexPath.row {
                    
                    case 0:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                        cell.delegate = self
                        cell.setCell("First name", false, "Your first name...", .default, ("firstname", data["firstname"] ?? ""))
                        return cell
                        
                    case 1:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                        cell.delegate = self
                        cell.setCell("Last name", false, "Your last name...", .default, ("lastname", data["lastname"] ?? ""))
                        return cell
                        
                    case 2:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell
                        cell.delegate = self
                        cell.setCell("Date of birth", ("birthDate", data["birthDate"] ?? ""))
                        return cell
                    
                    case 3:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: RadioButtonsTableViewCell.identifier, for: indexPath) as! RadioButtonsTableViewCell
                        cell.delegate = self
                        cell.setCell("Male/Female", [("M", "Male"), ("F", "Female")], ("isMale", data["isMale"] ?? ""))
                        return cell
                    default:
                        return UITableViewCell()
                }
                
            case 2:
                switch indexPath.row {
                
                    case 0:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
                        cell.delegate = self
                        cell.gestureDelegate = self
                        cell.setCell("Description", ("description", data["description"] ?? ""))
                        return cell
                        
                    case 1:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                        cell.delegate = self
                        cell.setCell("E-Mail", false, "Your E-Mail...", UIKeyboardType.emailAddress, ("email", data["email"] ?? ""))
                        return cell
                        
                    case 2:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
                        cell.delegate = self
                        delegate = cell
                        cell.setCell("Avatar image")
                        return cell
                        
                    case 3:
                        let cell = registrationTableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
                        cell.delegate = self
                        return cell
                        
                    default:
                        return UITableViewCell()
                }
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = registrationTableView.dequeueReusableCell(withIdentifier: SectionHeader.identifier) as! SectionHeader
        
        var sectionName = ""
        
        if section == 0 {
            
            sectionName = "Username/Password"
        }
        else if section == 1{
            
            sectionName = "Personal Information"
        } else {
            
            sectionName = "Additional information"
        }
        
        headerView.setHeader(sectionName)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
//MARK: - ImagePicker Extension
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.image = image
            delegate?.setImage(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
extension RegistrationViewController: ImageEditorDelegate, TransferDelegate, GestureDelegate {
    
    func addGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        
        registrationTableView.addGestureRecognizer(recognizer)
    }
    
    
    func presentPicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func transferData(for key: String, with value: String) {
        
        data[key] = value
        print(data)
    }
}
extension RegistrationViewController: ActionDelegate {
    
    func actionHandler() {
        
        if checkForm() {
            
            guard let url = URL(string: "\(globalManager.apiURL)/profile/check_username/") else {
                return
            }
            
            subscribe(forNotification: Notification.Name("UsernameExists"))
            subscribe(forNotification: Notification.Name("EmailExists"))
            
            let jsonObject: [String : Any] = ["username" : data["username"]!]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
            
            globalManager.POST(url: url, data: jsonData, withSerializer: globalManager.usernameExists(_:), isAuthorized: false, completition: {[unowned self] in
                
                guard let url = URL(string: "\(globalManager.apiURL)/profile/check_email/") else{
                    return
                }
                
                let jsonObject: [String : Any] = ["email" : data["email"]!]
                
                let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
                
                globalManager.POST(url: url, data: jsonData, withSerializer: globalManager.emailExists(_:), isAuthorized: false, completition: {
                    
                    guard let url = URL(string: "\(globalManager.apiURL)/profile/") else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        displayContentController(content: loadingVC)
                    }
                    
                    if let jsonObject = globalManager.registrationJSON(from: data) {
                        
                        globalManager.POST(url: url, data: jsonObject, withSerializer: globalManager.registrationSerializer(_:), isAuthorized: false, completition:  {[unowned self] in
                            
                            let username = data["username"]!
                            let password = data["password"]!
                            
                            if username != "" && password != "" {
                                
                                subscribe(forNotification: Notification.Name("loginSuccess"))
                                subscribe(forNotification: Notification.Name("loginUnsuccess"))
                                globalManager.tokenInit(username: username, password: password)
                            }
                        })
                    }
                })
            })
            
        }
        
    }
}
