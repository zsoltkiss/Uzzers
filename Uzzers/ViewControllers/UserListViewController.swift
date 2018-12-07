//
//  ViewController.swift
//  Uzzers
//
//  Created by Kiss Rudolf Zsolt on 2018. 12. 05..
//  Copyright © 2018. Kiss Rudolf Zsolt. All rights reserved.
//

import UIKit
import RealmSwift

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users: Results<User>!
    private let cellID = "UserCell"
    
    private var theRealm: Realm?

    override func viewDidLoad() {
        super.viewDidLoad()
        theRealm = try? Realm()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsers()
    }

    private func fetchUsers() {
        guard let realm = theRealm else {
            print("Realm instance hasn't been inited...")
            return
        }
        
        print("Realm file: \(String(describing: realm.configuration.fileURL))")
        users = realm.objects(User.self)
        print("Users fetched: \(String(describing: users))")
        tableView.reloadData()
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

