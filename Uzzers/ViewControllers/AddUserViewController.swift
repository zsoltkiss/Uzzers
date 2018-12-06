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
    @IBOutlet weak var tfEmail: UITextField!
    
    private var emailAddresses = [String]()
    private let cellID = "EmailAddressCell"
    
    private var theRealm: Realm?
    
    private enum ValidationError: String {
        case invalidEmailAddress = "error.invalidEmail"
        case missingEmailAddress = "error.missingEmail"
        case missingName = "error.missingName"
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
            print(error.rawValue)
            // TODO: display error to users
        } else {
            print("No validation error")
            
            // TODO: add UI element to set birthday
            
            var emailObjects = [EmailAddress]()
            
            let newUser = User(name: tfName.text!, timestamp: Date().timeIntervalSince1970)
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
        
        if !emailAddresses.contains(newEmail) {
            emailAddresses.append(newEmail)
            print("Email address to add: \(newEmail)")
        }
        
        tfEmail.text = nil
        
        tableView.reloadData()
    }
    
    private func validate() -> ValidationError? {
        // TODO: add email validation
        
        guard emailAddresses.count > 0 else {
            return ValidationError.missingEmailAddress
        }
        
        guard tfName.text?.isEmpty == false else {
            return ValidationError.missingName
        }
        
        return nil
    }
    
    private func dismissEditor() {
        guard let nc = self.navigationController else {
            return
        }
        
        nc.popViewController(animated: true)
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
