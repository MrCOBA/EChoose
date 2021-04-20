//
//  AlertsController.swift
//  EChoose
//
//  Created by Oparin Oleg on 31.03.2021.
//  Copyright © 2021 Oparin Oleg. All rights reserved.
//

import Foundation
import UIKit

class AlertGenerator {
    
    private var firstAction: ((UIAlertAction) -> Void)?
    private var secondAction: ((UIAlertAction) -> Void)?
    
    init(firstAction: ((UIAlertAction) -> Void)? = nil, secondAction: ((UIAlertAction) -> Void)? = nil) {
        
        self.firstAction = firstAction
        self.secondAction = secondAction
    }
    
    func getAlert() -> Alert {
        
        guard let firstAction = firstAction else {
            return InformationAlert()
        }
        
        guard let secondAction = secondAction else {
            return WarningAlert(action: firstAction)
        }
        
        return ActionsAlert(firstAction: firstAction, secondAction: secondAction)
    }
}

enum AlertType {
    
    //All Forms
    case fillAllGaps
    
    //Login Form
    case incorrecLoginData
    
    //Registration Form
    case existsUsername
    case incorrectUsernameFormat
    case existsEmail
    case notSimilarPasswords
    case incorrectEmailFormat
    case incorrectPasswordFormat
    
    //Service Form
    case notChoseAddress
    case notChoseServiceType
    
    //Address Form
    case willDeleteServices
    
    //Sheet Alert Type with 2 actions
    case matchActions
    case archiveActions
}
extension AlertType: RawRepresentable {

    typealias RawValue = (String, String)
    
    var rawValue: (String, String) {
        switch self {
        case .fillAllGaps:
            return ("Something going wrong!", "Fill all required gaps...")
        case .incorrecLoginData:
            return ("Incorrect username or password!", "Check username and password...")
        case .incorrectUsernameFormat:
            return("Wrong username format!", "It should contains from at least 6 (a-b, A-B, 0-9) symbols!")
        case .incorrectPasswordFormat:
            return("Wrong password format!", "It should contains from at least 8 (a-b, A-B, 0-9) symbols!\n And has at least 1 (a-b), at least 1 (A-B) and at least 1 (0-9) symbol!")
        case .existsUsername:
            return ("This username already exists!", "Try another username...")
        case .existsEmail:
            return ("This email has already taken!", "Try another email...")
        case .notSimilarPasswords:
            return ("Password and rep. password not matches!", "Enter similar passwords...")
        case .incorrectEmailFormat:
            return ("Something going wrong!", "Check your e-mail format!")
        case .notChoseAddress:
            return ("Address for study was not chose!", "Please select address of studying or choose remote education type!")
        case .notChoseServiceType:
            return ("Service type was not chose!", "Please select at least one service type!")
        case .willDeleteServices:
            return ("Warning!", "All services with this address will be deleted! Are you sure?")
        case .matchActions:
            return ("What do you want?", "Dislike or archive offer?")
        case .archiveActions:
            return ("What do you want?", "Like or dislike offer?")
        }
    }
    
    init?(rawValue: (String, String)) {
        
        switch rawValue {
        case ("Something going wrong!", "Fill all required gaps..."):
            self = .fillAllGaps
        case ("Incorrect username or password!", "Check username and password..."):
            self = .incorrecLoginData
        case ("Wrong username format!", "It should contains from at least 6 (a-b, A-B, 0-9) symbols!"):
            self = .incorrectUsernameFormat
        case ("Wrong password format!", "It should contains from at least 8 (a-b, A-B, 0-9) symbols!\n And has at least 1 (a-b), at least 1 (A-B) and at least 1 (0-9) symbol!"):
            self = .incorrectPasswordFormat
        case ("This username already exists!", "Try another username..."):
            self = .existsUsername
        case ("This email has already taken!", "Try another email..."):
            self = .existsEmail
        case ("Password and rep. password not matches!", "Enter similar passwords..."):
            self = .notSimilarPasswords
        case ("Something going wrong!", "Check your e-mail format!"):
            self = .incorrectEmailFormat
        case ("Address for study was not chose!", "Please select address of studying or choose remote education type!"):
            self = .notChoseAddress
        case ("Service type was not chose!", "Please select at least one service type!"):
            self = .notChoseServiceType
        case ("Warning!", "All services with this address will be deleted! Are you sure?"):
            self = .willDeleteServices
        case ("What do you want?", "Dislike or archive offer?"):
            self = .matchActions
        case ("What do you want?", "Like or dislike offer?"):
            self = .archiveActions
        default:
            return nil
        }
    }
    
}

protocol Alert {
    subscript(type: AlertType) -> UIAlertController? { get }
}

class InformationAlert: Alert {
    
    final private var availableTypes: [AlertType] = [.fillAllGaps,
                                                     .incorrecLoginData,
                                                     .existsUsername,
                                                     .existsEmail,
                                                     .notSimilarPasswords,
                                                     .incorrectEmailFormat,
                                                     .incorrectUsernameFormat,
                                                     .incorrectPasswordFormat]
    
    private var controller: UIAlertController?
    
    subscript(type: AlertType) -> UIAlertController? {
        
        get {
            if !availableTypes.contains(type) {
                return nil
            }
            
            controller = UIAlertController(title: type.rawValue.0, message: type.rawValue.1, preferredStyle: .alert)
            controller?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            return controller
        }
    }
}

class WarningAlert: Alert {
    
    final private var availableTypes: [AlertType] = [.notChoseAddress,
                                                     .notChoseServiceType,
                                                     .willDeleteServices]
    
    private var controller: UIAlertController?
    private var action: ((UIAlertAction) -> Void)
    
    init(action: @escaping ((UIAlertAction) -> Void)) {
        self.action = action
    }
    
    subscript(type: AlertType) -> UIAlertController? {
        
        get {
            if !availableTypes.contains(type) {
                return nil
            }
            
            controller = UIAlertController(title: type.rawValue.0, message: type.rawValue.1, preferredStyle: .alert)
            controller?.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
            controller?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            return controller
        }
    }
}

class ActionsAlert: Alert {
    
    final private var availableTypes: [AlertType] = [.matchActions,
                                                     .archiveActions]
    
    private var controller: UIAlertController?
    private var firstAction: ((UIAlertAction) -> Void)
    private var secondAction: ((UIAlertAction) -> Void)
    
    init(firstAction: @escaping ((UIAlertAction) -> Void), secondAction: @escaping ((UIAlertAction) -> Void)) {
        self.firstAction = firstAction
        self.secondAction = secondAction
    }
    
    subscript(type: AlertType) -> UIAlertController? {
        
        get {
            if !availableTypes.contains(type) {
                return nil
            }
            
            var actionTitles: (String, String) = ("", "")
            
            switch type {
            case .matchActions:
                actionTitles.0 = "Archive"
                actionTitles.1 = "Dislike"
            case .archiveActions:
                actionTitles.0 = "Like"
                actionTitles.1 = "Dislike"
            default:
                return nil
            }
            
            controller = UIAlertController(title: type.rawValue.0, message: type.rawValue.1, preferredStyle: .actionSheet)
            controller?.addAction(UIAlertAction(title: actionTitles.0, style: .default, handler: firstAction))
            controller?.addAction(UIAlertAction(title: actionTitles.1, style: .destructive, handler: secondAction))
            
            return controller
        }
    }
}
