//
//  ViewController.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/24/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ConfigureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var contacts = [Contact]()
    
    var messages = [Message]()
    
    let manager = CLLocationManager()
        
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
        
        //Location code
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        updateMessageField()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("There was an error with the Geocoder().reverse")
                print(error?.localizedDescription)
            }
            else {
                if let place = placemark?[0] {
                    var newLocationMessage = "I'm at: "
                    if let name = place.name {
                       newLocationMessage.append(name)
                    }
                    if let subLocality = place.subLocality {
                        newLocationMessage.append(", \(subLocality)")
                    }
                    if let locality = place.locality {
                        newLocationMessage.append(", \(locality)")
                    }
                    if let adminArea = place.administrativeArea {
                        newLocationMessage.append(", \(adminArea)")
                    }
                    if let postalCode = place.postalCode {
                        newLocationMessage.append(", \(postalCode)")
                    }
                    if let countryCode = place.isoCountryCode {
                        newLocationMessage.append(", \(countryCode)")
                    }
                    self.updateMessageField()
                    if self.messages.isEmpty { return }
                    MessageService.edit(message: (self.messages.first)!, mainMessage: (self.messages.first?.mainMessage)!, locationMessage: newLocationMessage)
                    self.updateMessageField()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ContactService.contacts(for: User.current) { (contacts) in
            self.contacts = contacts
            self.scrollableTableView.reloadData()
        }
        updateMessageField()
    }
    
    @IBAction func editMessageButtonPressed(_ sender: UIButton) {
        
        let addAlert = UIAlertController(title: "Emergency Message", message: "Edit your message", preferredStyle: .alert)
        
        addAlert.addTextField { (textField: UITextField) in
            textField.placeholder  = "\(self.messages.first?.mainMessage ?? "mainMessage") \(self.messages.first?.locationMessage ?? "locationMessage")"
        }
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        addAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            guard let message = addAlert.textFields?.first?.text else { return }
            if message != "" {
                MessageService.messages(for: User.current) { (messages) in
                    self.messages = messages
                }
                if self.messages.isEmpty { return }
                MessageService.edit(message: (self.messages.first)!, mainMessage: message, locationMessage: (self.messages.first?.locationMessage)!)
                self.updateMessageField()
            }
        }))
        
        self.present(addAlert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMessageField() {
        MessageService.messages(for: User.current) { (messages) in
            self.messages = messages
            self.messageTextLabel.text = "\(messages.first?.mainMessage ?? "loadingMainMessage") \(messages.first?.locationMessage ?? "loadingLocationMessage")"
        }
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

