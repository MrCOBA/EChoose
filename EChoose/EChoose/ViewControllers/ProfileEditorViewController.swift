//
//  ProfileEditorViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 17.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import UIKit

struct ProfileEditorSectionsSizes {
    
    static var firstSection: Int = 4
    static var secondSection: Int = 4
}

class ProfileEditorViewController: UIViewController {

    @IBOutlet weak var profileEditorTableView: UITableView!
    
    private var image: UIImage?
    var delegate: ImageDelegate?
    var imagePicker = UIImagePickerController()
    var globalManager: GlobalManager = GlobalManager.shared
    var data: [String : String] = [:]
    let loadingVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        profileEditorTableView.delegate = self
        profileEditorTableView.dataSource = self
        
        //First cell type
        profileEditorTableView.register(UINib(nibName: TextFieldTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        //Fourth cell type
        profileEditorTableView.register(UINib(nibName: DatePickerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        //Fifth cell type
        profileEditorTableView.register(UINib(nibName: TextViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TextViewTableViewCell.identifier)
        //Seventh cell type
        profileEditorTableView.register(UINib(nibName: ButtonTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        //Eighth cell type
        profileEditorTableView.register(UINib(nibName: ImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageTableViewCell.identifier)
        //Nineth cell type
        profileEditorTableView.register(UINib(nibName: RadioButtonsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RadioButtonsTableViewCell.identifier)
        //Header
        profileEditorTableView.register(UINib(nibName: SectionHeader.identifier, bundle: nil), forCellReuseIdentifier: SectionHeader.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayContentController(content: loadingVC)
        guard let url = URL(string: "\(globalManager.apiURL)/profile/") else {
            return
        }
        
        globalManager.GET(url: url, data: nil, withSerializer: profileSerializer(_:), isAuthorized: true, completition: {[unowned self] in
            
            if data["image"] ?? "" != "" {
                
                guard let url = URL(string: "\(globalManager.apiURL)/\(data["image"] ?? "")/") else {
                    return
                }
                
                globalManager.downloadImage(from: url, completition: {
                    DispatchQueue.main.async {
                        if let image = globalManager.buffer as? UIImage {
                            self.image = image
                        }
                        hideContentController(content: loadingVC)
                        profileEditorTableView.reloadData()
                    }
                })
                
            } else {
                
                DispatchQueue.main.async {
                    hideContentController(content: loadingVC)
                    profileEditorTableView.reloadData()
                }
            }
        })
        
        setUI()
    }
    
    
    func setUI() {
        
        profileEditorTableView.layer.cornerRadius = 20
        self.overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func displayContentController(content: UIViewController) {
        tabBarController?.addChild(content)
        tabBarController?.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }

}
extension ProfileEditorViewController {
    
    func profileSerializer(_ data: Any) -> Bool {
        
        guard let json = globalManager.perform(data: data) as? [String : Any] else {
            return false
        }
        
        if let id = json["id"] as? Int32 {
            self.data["id"] = "\(id)"
        }
        
        if let userData = json["user"] as? [String : Any] {
            
            let firstname = userData["first_name"] as? String
            let lastname = userData["last_name"] as? String
            let email = userData["email"] as? String
            
            self.data["firstname"] = firstname
            self.data["lastname"] = lastname
            self.data["email"] = email
        }
        
        if let isMale = json["isMale"] as? Bool{
            self.data["isMale"] = isMale ? "True" : "False"
        }
        
        if let description = json["description"] as? String {
            self.data["description"] = description
        }
        
        if let birthDate = json["birth_date"] as? String{
            self.data["birthDate"] = birthDate
        }
        
        if let image = json["image"] as? String {
            self.data["image"] = image
        } else {
            self.data["image"] = ""
        }
        return true
    }
    
}
extension ProfileEditorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return ProfileEditorSectionsSizes.firstSection
            
        } else if section == 1 {
            
            return ProfileEditorSectionsSizes.secondSection
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                
                case 0:
                    let cell = profileEditorTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                    cell.delegate = self
                    cell.setCell("First name", false, "Your first name...", .default, ("firstname", data["firstname"] ?? ""))
                    return cell
                    
                case 1:
                    let cell = profileEditorTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                    cell.delegate = self
                    cell.setCell("Last name", false, "Your last name...", .default, ("lastname", data["lastname"] ?? ""))
                    return cell
                    
                case 2:
                    let cell = profileEditorTableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell
                    cell.delegate = self
                    
                    cell.setCell("Date of birth", ("birthDate", data["birthDate"] ?? ""))
                    return cell
                
                case 3:
                    let cell = profileEditorTableView.dequeueReusableCell(withIdentifier: RadioButtonsTableViewCell.identifier, for: indexPath) as! RadioButtonsTableViewCell
                    cell.delegate = self
                    cell.setCell("Male/Female", [("M", "Male"), ("F", "Female")], ("isMale", data["isMale"] ?? ""))
                    return cell
                default:
                    return UITableViewCell()
            }
        
        case 1:
            switch indexPath.row {
            
                case 0:
                    let cell = profileEditorTableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
                    cell.delegate = self
                    cell.gestureDelegate = self
                    cell.setCell("Description", ("description", data["description"] ?? ""))
                    return cell
                    
                case 1:
                    let cell = profileEditorTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                    cell.delegate = self
                    cell.setCell("E-Mail", false, "Your E-Mail...", UIKeyboardType.emailAddress, ("email", data["email"] ?? ""))
                    return cell
                    
                case 2:
                    let cell = profileEditorTableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
                    cell.delegate = self
                    delegate = cell
                    
                    delegate?.setImage(image ?? UIImage(named: "addimage")!)
                    cell.setCell("Avatar image")
                    return cell
                    
                case 3:
                    let cell = profileEditorTableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
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
        
        let headerView = profileEditorTableView.dequeueReusableCell(withIdentifier: SectionHeader.identifier) as! SectionHeader
        
        var sectionName = ""
        
        if section == 0 {
            
            sectionName = "Personal Information"
        }
        else if section == 1{
            
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
extension ProfileEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.image = image
            delegate?.setImage(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
extension ProfileEditorViewController: ImageEditorDelegate, TransferDelegate, GestureDelegate {
    
    func addGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        
        profileEditorTableView.addGestureRecognizer(recognizer)
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
extension ProfileEditorViewController: ActionDelegate {
    
    func actionHandler() {
        
        displayContentController(content: loadingVC)
        
        guard let url = URL(string: "\(globalManager.apiURL)/profile/update/") else {
            hideContentController(content: loadingVC)
            return
        }
        
        guard let jsonData = globalManager.updateJSON(from: data) else {
            hideContentController(content: loadingVC)
            return
        }
        
        globalManager.PUT(url: url, data: jsonData, withSerializer: nil, isAuthorized: true, completition: {[unowned self] in
            
            if let image = image {
                
                globalManager.POSTimage(url: nil, image: image, withSerializer: nil, completition: {
                    
                    DispatchQueue.main.async {[unowned self] in
                        hideContentController(content: loadingVC)
                        navigationController?.popToRootViewController(animated: true)
                    }
                })
            } else {
                
                DispatchQueue.main.async {[unowned self] in
                    hideContentController(content: loadingVC)
                    navigationController?.popToRootViewController(animated: true)
                }
            }
        })
    }
}
