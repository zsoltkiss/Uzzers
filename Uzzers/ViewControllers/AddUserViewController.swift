//
//  AddUserViewController.swift
//  Uzzers
//
//  Created by Kiss Rudolf Zsolt on 2018. 12. 06..
//  Copyright © 2018. Kiss Rudolf Zsolt. All rights reserved.
//

import UIKit
import RealmSwift

class AddUserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDateOfBirth: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    private var emailAddresses = [String]()
    private let cellID = "EmailAddressCell"
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private let errorTitle = NSLocalizedString("error.title", comment: "")
    
    private enum ValidationError: String {
        case invalidEmailAddress = "error.invalidEmail"
        case missingEmailAddress = "error.missingEmail"
        case missingName = "error.missingName"
        case nameDuplication = "error.nameAlreadyExists"
        case emailAddressDuplication = "error.emailAddressAlreadyExists"
        case invalidDate = "error.invalidDateOfBirth"
        
        var localizedDescription: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
    }
    
    @IBAction func createButtonDidTap(_ sender: UIButton) {
        if let error = validate() {
            switch error {
            case .nameDuplication:
                tfName.text = nil
            case .invalidDate:
                tfDateOfBirth.text = nil
            default:
                break
            }
            
            displayError(message: error.localizedDescription)
        } else {
            var emailObjects = [EmailAddress]()
            let birthDate = buildDate(from: tfDateOfBirth.text!)
            
            let newUser = User(name: tfName.text!, timestamp: birthDate!.timeIntervalSince1970)
            emailAddresses.forEach { (anEmail) in
                let anObject = EmailAddress(email: anEmail, user: newUser)
                emailObjects.append(anObject)
            }
            
            if let _ = DBService.shared.addUser(newUser, emails: emailObjects) {
                displayError(message: NSLocalizedString("error.persistenceError", comment: ""))
            } else {
                dismissEditor()
            }
        }
    }
    
    @IBAction func addButtonDidTap(_ sender: UIButton) {
        guard tfEmail.text?.isEmpty == false else {
            return
        }
        
        let newEmail = tfEmail.text!
        
        guard isValidEmail(userInput: newEmail) else {
            displayError(message: ValidationError.invalidEmailAddress.localizedDescription)
            return
        }
        
        guard emailAddresses.contains(newEmail) == false else {
            tfEmail.text = nil
            displayError(message: ValidationError.emailAddressDuplication.localizedDescription)
            return
        }
        
        emailAddresses.append(newEmail)
        if (UIApplication.shared.delegate as! AppDelegate).isDebug {
            print("Email address to add: \(newEmail)")
        }
        
        tfEmail.text = nil
        tableView.reloadData()
    }
    
    private func validate() -> ValidationError? {
        guard let userInputName = tfName.text else {
            return ValidationError.missingName
        }
        
        guard userInputName.isEmpty == false else {
            return ValidationError.missingName
        }
        
        guard DBService.shared.isNameExist(name: userInputName) == false else {
            return ValidationError.nameDuplication
        }
        
        guard let userInputDate = tfDateOfBirth.text else {
            return ValidationError.invalidDate
        }
        
        guard let _ = buildDate(from: userInputDate) else {
            return ValidationError.invalidDate
        }
        
        guard emailAddresses.count > 0 else {
            return ValidationError.missingEmailAddress
        }
        
        return nil
    }
    
    private func isValidEmail(userInput: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: userInput)
    }
    
    private func retrieveDate(from userInput: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = NSCalendar.current
        formatter.timeZone = TimeZone.current
        
        if let birthDate = formatter.date(from: userInput) {
            if (UIApplication.shared.delegate as! AppDelegate).isDebug {
                print("Valid birth date: \(birthDate)")
            }
            return birthDate
        }
        
        return nil
    }
    
    private func buildDate(from userInput: String) -> Date? {
        let parts = userInput.split(separator: "-")
        
        guard parts.count == 3 else {
            return nil
        }
        
        if (UIApplication.shared.delegate as! AppDelegate).isDebug {
            print("Date components: \(parts)")
        }
        
        guard parts[0].count == 4 else {
            return nil
        }
        
        guard parts[1].count == 2 else {
            return nil
        }
        
        guard parts[2].count == 2 else {
            return nil
        }
        
        let cal = Calendar(identifier: .gregorian)
        let comps = DateComponents(calendar: cal, timeZone: TimeZone.current, era: nil, year: (parts[0] as NSString).integerValue, month: (parts[1] as NSString).integerValue, day: (parts[2] as NSString).integerValue, hour: 12, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        return cal.date(from: comps)
    }
    
    private func dismissEditor() {
        guard let nc = self.navigationController else {
            return
        }
        
        nc.popViewController(animated: true)
    }
    
    private func displayError(message: String) {
        let alertController = UIAlertController(title: errorTitle, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionOK)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension AddUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = emailAddresses[indexPath.row]
        return cell
    }
}
