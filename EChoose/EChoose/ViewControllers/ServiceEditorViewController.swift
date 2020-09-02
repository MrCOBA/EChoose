//
//  ServiceEditorViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 29.08.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit

enum EditorMode {
    
    case newService
    case editService
}

class ServiceEditorViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var subjectSearchBar: UISearchBar!
    @IBOutlet weak var subjectPickerView: UIPickerView!
    @IBOutlet weak var workTypeBackgroundView: UIView!
    @IBOutlet weak var descriptionBackgroundView: UIView!
    @IBOutlet weak var workTypePickerView: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var hardRatingStackView: RatingController!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costStepper: UIStepper!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    private var textViewCenter: CGPoint!
    private var keyboardHeight: CGFloat!
    private var subjects: [String] = []
    private var filteredSubjects: [String] = []
    private var subject2ID: [String: Int] = [:]
    private var workType2ID: [String: Int] = ["Homework": 0, "Practice": 1, "Olympiad": 2, "Exam preparation": 3, "Level-Up": 4, "Consultation": 5, "Any": 6]
    private var workTypes: [String] = ["Homework", "Practice", "Olympiad", "Exam preparation", "Level-Up", "Consultation", "Any"]
    var cost = 0
    var row: Int!
    var mode: EditorMode!
    var service: ServiceStruct?
    var servicesController: MyServicesViewController!
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
        subjectPickerView.delegate = self
        subjectPickerView.dataSource = self
        workTypePickerView.delegate = self
        workTypePickerView.dataSource = self
        subjectSearchBar.delegate = self
        descriptionTextView.delegate = self
        
        let gestureRecognizer_BlurView = UITapGestureRecognizer(target: self, action: #selector(touchBlurViewHandler(_:)))
        blurView.addGestureRecognizer(gestureRecognizer_BlurView)
        let gestureRecognizer_MainView = UITapGestureRecognizer(target: self, action: #selector(touchMainViewHandler(_:)))
        view.addGestureRecognizer(gestureRecognizer_MainView)
        let gestureRecognizer_CostLabel = UITapGestureRecognizer(target: self, action: #selector(touchCostLabelHandler(_:)))
        backgroundView.addGestureRecognizer(gestureRecognizer_CostLabel)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        setUI()
    }
    
    private func setUI() {
        
        self.overrideUserInterfaceStyle = .light
        
        switch mode {
            
        case .newService:
            self.navigationItem.title = "New Service"
            setEditor()
            
        case .editService:
            self.navigationItem.title = "Edit Service"
            self.subjectPickerView.selectRow(subject2ID[service!.subject]!, inComponent: 0, animated: true)
            self.workTypePickerView.selectRow(workType2ID[service!.typeOfWork]!, inComponent: 0, animated: true)
            self.cost = service!.cost
            self.descriptionTextView.text = service!.description
            self.hardRatingStackView.setStarsRating(rating: service!.hardLevel)
            setEditor()
            
        case .none:
            self.navigationItem.title = "Service Editor"
        }
        
        let backgroundViews = [workTypeBackgroundView, descriptionBackgroundView]
        
        subjectSearchBar.layer.borderWidth = 1;
        subjectSearchBar.layer.borderColor = backgroundView.backgroundColor?.cgColor
        
        for view in backgroundViews {
            view!.layer.cornerRadius = 10
            view!.layer.shadowColor = UIColor.black.cgColor
            view!.layer.shadowOffset = .zero
            view!.layer.shadowOpacity = 0.5
            view!.layer.shadowRadius = 5
        }
        
        descriptionTextView.layer.cornerRadius = 10
        
        costStepper.layer.cornerRadius = 10
        costStepper.tintColor = UIColor.yellow
    }
    
    func setEditor() {
        
        self.costLabel.text = "Cost: \(cost)₽"
        self.costStepper.value = Double((cost / 100 ) * 100)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight
        }
    }
    
    @objc
    private func touchBlurViewHandler(_ recognizer: UITapGestureRecognizer) {
        
        descriptionTextView.resignFirstResponder()
    }
    
    @objc
    private func touchMainViewHandler(_ recognizer: UITapGestureRecognizer) {
        
        subjectSearchBar.resignFirstResponder()
    }
    
    @objc
    private func touchCostLabelHandler(_ recognizer: UITapGestureRecognizer) {
        
        let touchPoint = recognizer.location(in: backgroundView)
        
        if self.costLabel.frame.contains(touchPoint) {
            let alert = UIAlertController(title: "Cost of your service", message: nil, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { textfield in
                textfield.placeholder = "Input cost here..."
                textfield.keyboardType = .numberPad
                })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                if let cost = Int((alert.textFields?.first?.text)!) {
                    self.cost = cost
                    self.costStepper.value = Double((cost / 100) * 100)
                    self.costLabel.text = "Cost: \(cost)₽"
                }
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func confirmChanges(_ sender: Any) {
        
        switch mode {
            
        case .editService:
            if subjectSearchBar.text != "" && filteredSubjects.count != 0{
                service?.subject = filteredSubjects[subjectPickerView.selectedRow(inComponent: 0)]
            } else if subjectSearchBar.text == "" {
                service?.subject = subjects[subjectPickerView.selectedRow(inComponent: 0)]
            }
            
            service?.typeOfWork = workTypes[workTypePickerView.selectedRow(inComponent: 0)]
            service?.cost = self.cost
            service?.hardLevel = hardRatingStackView.starsRating
            service?.description = descriptionTextView.text
            self.servicesController.services[row] = service!
            performSegue(withIdentifier: "backToServices", sender: nil)
        
        case .newService:
            
            var subject: String = ""
            if subjectSearchBar.text != "" && filteredSubjects.count != 0{
                subject = filteredSubjects[subjectPickerView.selectedRow(inComponent: 0)]
            } else if subjectSearchBar.text == "" {
                subject = subjects[subjectPickerView.selectedRow(inComponent: 0)]
            } else {
                
                let alert = UIAlertController(title: "Error!", message: "Select a subject!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            service = ServiceStruct(
                subject: subject,
                typeOfWork: workTypes[workTypePickerView.selectedRow(inComponent: 0)],
                cost: self.cost,
                description: descriptionTextView.text,
                hardLevel: hardRatingStackView.starsRating)
            
            self.servicesController.services.append(service!)
            performSegue(withIdentifier: "backToServices", sender: nil)
            
        case .none:
            break
        }
    }
    
    @IBAction func costChanged(_ sender: Any) {
        
        generator.prepare()
        generator.impactOccurred()
        cost = Int(costStepper.value)
        self.costLabel.text = "Cost: \(cost)₽"
    }
    
    
    private func initData() {
        
        if let path = Bundle.main.path(forResource: "Subjects", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: [])
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json as? [String: [[String: Any]]] {
                    
                    let subjects: [[String: Any]] = json["subjects"]!
                    for subject in subjects {
                        let name = subject["name"] as? String
                        let id = subject["id"] as? Int
                        self.subjects.append(name!)
                        self.subject2ID[name!] = id
                    }
                }
            } catch {
                print("Error!")
            }
        }
    }
}
extension ServiceEditorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == subjectPickerView {
            
            if subjectSearchBar.text != "" {
                return filteredSubjects.count
            }
            else {
                return subjects.count
            }
        }
        else {
            
            return workTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == subjectPickerView {
            
            if subjectSearchBar.text != "" {
                return filteredSubjects[row]
            }
            else {
                return subjects[row]
            }
        }
        else {
            
            return workTypes[row]
        }
    }
    
}
extension ServiceEditorViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredSubjects = subjects.filter{(subject) -> Bool in
            
            return subject.lowercased().contains(searchBar.text!.lowercased())
        }
        
        self.subjectPickerView.reloadComponent(0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
}
extension ServiceEditorViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.textViewCenter = textView.center
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.isHidden = false
            textView.center = CGPoint(x: textView.center.x, y: textView.center.y - self.keyboardHeight / 2)
        })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        UIView.animate(withDuration: 0.5, animations: {
            textView.center = self.textViewCenter
            self.blurView.isHidden = true
        })
    }
}
