//
//  ViewController.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/24/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import UIKit

class ConfigureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var contacts = [Contact]()
        
    @IBOutlet weak var scrollableTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view, typically from a nib.
        scrollableTableView.delegate = self
        scrollableTableView.dataSource = self
        ContactService.contacts(for: User.current) { (contacts) in
            self.contacts = contacts
            self.scrollableTableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        ContactService.contacts(for: User.current) { (contacts) in
            self.contacts = contacts
            self.scrollableTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScrollableContactCell", for: indexPath) as! ScrollableContactCell

        let contact = contacts[indexPath.row]
        let name = contact.name

        cell.nameLabel.text = name

        return cell
    }
    
}

