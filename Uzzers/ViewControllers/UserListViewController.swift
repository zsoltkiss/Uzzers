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
    @IBOutlet weak var lbNoResults: UILabel!
    
    private var users: Results<User>!
    private let cellID = "UserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsers()
    }

    private func fetchUsers() {
        users = DBService.shared.fetchUsers()
        if (UIApplication.shared.delegate as! AppDelegate).isDebug {
            print("Users fetched: \(String(describing: users))")
        }
        
        if users.count > 0 {
            tableView.isHidden = false
            lbNoResults.isHidden = true
            tableView.reloadData()
        }
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

