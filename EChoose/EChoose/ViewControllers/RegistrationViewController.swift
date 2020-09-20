//
//  RegistrationViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 30.07.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit
import CoreData

struct RegistrationSectionsSizes {
    
    static var firstSection: Int = 3
    static var secondSection: Int = 4
    static var thirdSection: Int = 4
}

struct UserStruct {
    
    var username: String
    var fullname: String
    var password: String
    var age: Int
    var role: String
    var email: String
    var descript: String
    var city: String
    var image: UIImage
}

class RegistrationViewController:UIViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var registrationTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    var user: User!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationTableView.delegate = self
        registrationTableView.dataSource = self
        
        //First cell type
        registrationTableView.register(UINib(nibName: TextFieldTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        //Second cell type
        registrationTableView.register(UINib(nibName: RadioButtonsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RadioButtonsTableViewCell.identifier)
        //Third cell type
        registrationTableView.register(UINib(nibName: PickerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PickerTableViewCell.identifier)
        //Fourth cell type
        registrationTableView.register(UINib(nibName: DatePickerTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DatePickerTableViewCell.identifier)
        //Fifth cell type
        registrationTableView.register(UINib(nibName: TextViewTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TextViewTableViewCell.identifier)
        //Sixth cell type
        registrationTableView.register(UINib(nibName: DoublePickerCell.identifier, bundle: nil), forCellReuseIdentifier: DoublePickerCell.identifier)
        //Seventh cell type
        registrationTableView.register(UINib(nibName: ButtonTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        //Header
        registrationTableView.register(UINib(nibName: SectionHeader.identifier, bundle: nil), forCellReuseIdentifier: SectionHeader.identifier)
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    //MARK: - Setting up UI
    func setUI(){
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        self.overrideUserInterfaceStyle = .light
        
        registrationTableView.layer.cornerRadius = 20
        registrationTableView.separatorStyle = .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mainViewSegue" {
            let destination = segue.destination as! UITabBarController
            
            destination.selectedIndex = 2
            destination.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    //MARK Actions
    @IBAction func backSwipeHandler(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        let user = UserStruct(
            username: "mrcoba",
            fullname: "Oparin Oleg",
            password: "Olezhan08",
            age: 20,
            role: "Student",
            email: "oparin@edu.hse.ru",
            descript: "I am 3-d course HSE student.",
            city: "Moscow",
            image: UIImage(named: "exampleimage")!)
        
        saveUser(user)
        performSegue(withIdentifier: "mainViewSegue", sender: nil)
    }
}
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
                
                cell.setCell("Username", false, "Username...")
                return cell
                
            case 1:
                let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                
                cell.setCell("Password", true, "Password...")
                return cell
                
            case 2:
                let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                
                cell.setCell("Repeat password", true, "Password again...")
                return cell
                
            default:
                return UITableViewCell()
            }
            
        case 1:
            
            switch indexPath.row {
                
            case 0:
                let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                
                cell.setCell("Full name", false, "Your full name...")
                return cell
                
            case 1:
                let cell = registrationTableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell
                
                cell.setCell("Date of birth")
                return cell
                
            case 2:
                let cell = registrationTableView.dequeueReusableCell(withIdentifier: DoublePickerCell.identifier, for: indexPath) as! DoublePickerCell
                
                cell.setCell("City")
                return cell
                
            case 3:
                let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
                
                cell.setCell("E-Mail", false, "Your E-Mail...", UIKeyboardType.emailAddress)
                return cell
                
            default:
                return UITableViewCell()
            }
            
        case 2:
        
        switch indexPath.row {
            
        case 0:
            let cell = registrationTableView.dequeueReusableCell(withIdentifier: RadioButtonsTableViewCell.identifier, for: indexPath) as! RadioButtonsTableViewCell
            
            cell.setCell("Role")
            return cell
            
        case 1:
            let cell = registrationTableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            
            cell.setCell("Description", registrationTableView)
            return cell

        case 2:
            let cell = registrationTableView.dequeueReusableCell(withIdentifier: PickerTableViewCell.identifier, for: indexPath) as! PickerTableViewCell
            
            cell.setCell("Place of work", ["Home of the student", "Home of the teacher", "School/University", "Other"])
            cell.superTableView = registrationTableView
            return cell
            
        case 3:
            let cell = registrationTableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as! ButtonTableViewCell
            
            cell.setCell("Address", self)
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
        else if section == 1 {
            
            sectionName = "Personal Information"
        }
        else {
            
            sectionName = "Educational Information"
        }
        
        headerView.setHeader(sectionName)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
extension UITableView {
    
    func scrollToBottom(animated: Bool) {
        guard let dataSource = dataSource else { return }
        var lastSection = (dataSource.numberOfSections?(in: self) ?? 1) - 1
        while dataSource.tableView(self, numberOfRowsInSection: lastSection) < 1 && lastSection > 0 {
            lastSection -= 1
        }
        let lastRow = dataSource.tableView(self, numberOfRowsInSection: lastSection) - 1
        guard lastSection > -1 && lastRow > -1 else { return }
        let indexPath = IndexPath(item: lastRow, section: lastSection)
        scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
}
//MARK: - CoreData Extension Functions
extension RegistrationViewController {
    
    func loadData() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do{
            try user = context.fetch(fetchRequest).first
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveUser(_ user: UserStruct) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if self.user == nil {
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! User
            
            taskObject.username = user.username
            taskObject.fullname = user.fullname
            taskObject.password = user.password
            taskObject.age = Int16(user.age)
            taskObject.image = user.image.pngData()
            taskObject.city = user.city
            taskObject.descript = user.descript
            taskObject.email = user.email
            taskObject.role = user.role
            
            do{
                try context.save()
                self.user = taskObject
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
