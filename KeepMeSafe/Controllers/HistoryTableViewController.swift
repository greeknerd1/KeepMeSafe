//
//  ViewController.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/24/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import UIKit
import AVFoundation

class HistoryTableViewController: UITableViewController {
    
    var audioFiles = [Audio]()
    
    var recordingSession: AVAudioSession!
    
    var avPlayer: AVPlayer? //here
    var avPlayerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayAndRecord in HistoryController.ViewDidLoad() failed.")
        }
        
        AudioService.getAllAudios(for: User.current) { (audioFiles) in
            self.audioFiles = audioFiles
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AudioService.getAllAudios(for: User.current) { (audioFiles) in
            self.audioFiles = audioFiles
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        avPlayer?.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as! AudioCell
        
        let audio = audioFiles[indexPath.row]
        let audioDate = audio.date
        
        cell.URLStringLabel.text = "Click to play recording!"
        cell.dateLabel.text = audioDate
        
        return cell
    }
    
    func formatDate(_ timestamp: String) -> String {
        let dateAndTime = timestamp.split(separator: "T")
        let date = dateAndTime[0]
        var time = dateAndTime[1]
        time.removeLast()
        return "Created on: \(date) at \(time)"
    }
    //plays audio when cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let audio = audioFiles[indexPath.row]
        let audioDownloadURLString = audio.audioURLString
        
        if let audioDownloadURL = URL(string: audioDownloadURLString) {
            avPlayerItem = AVPlayerItem.init(url: audioDownloadURL)
            avPlayer = AVPlayer.init(playerItem: avPlayerItem)
            avPlayer?.volume = 1.0
            avPlayer?.play()
        }
    }
    
    //delete function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let contactToDelete = contacts[indexPath.row]
//            ContactService.remove(contact: contactToDelete)
//            ContactService.contacts(for: User.current) { (contacts) in
//                self.contacts = contacts
//                self.tableView.reloadData()
//            }
        }
    }
}

