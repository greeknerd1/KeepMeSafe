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
    @IBOutlet weak var messageTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view, typically from a nib.
        scrollableTableView.delegate = self
        scrollableTableView.dataSource = self
        ContactService.contacts(for: User.current) { (contacts) in
            self.contacts = contacts
            self.scrollableTableView.reloadData()
        }
        messageTextLabel.text = "\(User.current.username) is deemed unsafe and may be in danger. You are one of their emergency contacts. Their current location is: LOCATION"
    }

    override func viewWillAppear(_ animated: Bool) {
        ContactService.contacts(for: User.current) { (contacts) in
            self.contacts = contacts
            self.scrollableTableView.reloadData()
        }
    }
    
    @IBAction func editMessageButtonPressed(_ sender: UIButton) {
        let addAlert = UIAlertController(title: "Emergency Message", message: "Edit your message", preferredStyle: .alert)
        addAlert.addTextField { (textField: UITextField) in
            textField.placeholder  = "\(User.current.username) is deemed unsafe and may be in danger. You are one of their emergency contacts. Their current location is: LOCATION" //change to get their location
        }
        addAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            guard let message = addAlert.textFields?.first?.text else { return }
            if message != "" {
                self.messageTextLabel.text = message
            }
        }))
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(addAlert, animated: true, completion: nil)
        
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

