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
    
    private var theRealm: Realm?
    
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
        theRealm = try? Realm()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
    }
    
    @IBAction func createButtonDidTap(_ sender: UIButton) {
        guard let realm = theRealm else {
            print("Realm instance hasn't been inited...")
            return
        }
        
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
            let birthDate = retrieveDate(from: tfDateOfBirth.text!)
            
            let newUser = User(name: tfName.text!, timestamp: birthDate!.timeIntervalSince1970)
            emailAddresses.forEach { (anEmail) in
                let anObject = EmailAddress(email: anEmail, user: newUser)
                emailObjects.append(anObject)
            }
            
            do {
                try realm.write {
                    realm.add(newUser)
                    print("User added.")
                    realm.add(emailObjects)
                    print("User's email addresses added.")
                    dismissEditor()
                }
            } catch {
                print("Error occured when persisting User object. \(error)")
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
        print("Email address to add: \(newEmail)")
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
        
        guard isNameExist(name: userInputName) == false else {
            return ValidationError.nameDuplication
        }
        
        guard let userInputDate = tfDateOfBirth.text else {
            return ValidationError.invalidDate
        }
        
        guard let _ = retrieveDate(from: userInputDate) else {
            return ValidationError.invalidDate
        }
        
        guard emailAddresses.count > 0 else {
            return ValidationError.missingEmailAddress
        }
        
        return nil
    }
    
    private func isNameExist(name: String) -> Bool {
        let results = theRealm!.objects(User.self).filter("name = %@", name)
        return results.count > 0
    }
    
    private func isValidEmail(userInput: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: userInput)
    }
    
    private func retrieveDate(from userInput: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let birthDate = formatter.date(from: userInput) {
            print("Valid birth date: \(birthDate)")
            return birthDate
        }
        
        return nil
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
