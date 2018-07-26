//
//  ViewController.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/24/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import UIKit
import ContactsUI

class EmergencyContactTableViewController: UITableViewController, CNContactPickerDelegate {
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactPhoneNumbersKey]
        
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPicker.predicateForSelectionOfContact = NSPredicate(format: "phoneNumbers.@count == 1")
        contactPicker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
        
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        let selectedContactName = contactProperty.contact.givenName
        let selectedContactPhoneNumber = (contactProperty.value as! CNPhoneNumber).value(forKey: "digits") as! String
        print(selectedContactName)
        print(selectedContactPhoneNumber)
    }
    
}
