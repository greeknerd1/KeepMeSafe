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
    let manager = CLLocationManager()
    
    var mainStringToDisplay = "USER is deemed unsafe and may be in danger. You are one of their emergency contacts. Their current location is:"
    var locationStringToDisplay = "LOCATION"
        
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
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        mainStringToDisplay = "\(User.current.username) is deemed unsafe and may be in danger. You are one of their emergency contacts. Their current location is:"
        messageTextLabel.text = "\(mainStringToDisplay) \(locationStringToDisplay)"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("There was an error with the Geocoder().reverse")
            }
            else {
                if let place = placemark?[0] {
                    //place.postalAddress! <-- this contains all the relevant location information
                
                    if let name = place.name {
                       self.locationStringToDisplay = name
                    }
                    if let subLocality = place.subLocality {
                        self.locationStringToDisplay.append(", \(subLocality)")
                    }
                    if let locality = place.locality {
                        self.locationStringToDisplay.append(", \(locality)")
                    }
                    if let adminArea = place.administrativeArea {
                        self.locationStringToDisplay.append(", \(adminArea)")
                    }
                    if let postalCode = place.postalCode {
                        self.locationStringToDisplay.append(", \(postalCode)")
                    }
                    if let countryCode = place.isoCountryCode {
                        self.locationStringToDisplay.append(", \(countryCode)")
                    }
                    self.messageTextLabel.text = "\(self.mainStringToDisplay) \(self.locationStringToDisplay)"
                }
            }
        }
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
            textField.placeholder  = "\(self.mainStringToDisplay) \(self.locationStringToDisplay)"
        }
        addAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) in
            guard let message = addAlert.textFields?.first?.text else { return }
            if message != "" {
                self.mainStringToDisplay = message
                self.messageTextLabel.text = "\(self.mainStringToDisplay) \(self.locationStringToDisplay)"
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

