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
            //print("Setting category to AVAudioSessionCategoryPlayAndRecord in HistoryController.ViewDidLoad() failed.")
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
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        AudioService.getAllAudios(for: User.current) { (audioFiles) in
            self.audioFiles = audioFiles
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as! AudioCell
        
        let audio = audioFiles[indexPath.row]
        let audioDate = audio.date
        let audioDuration = audio.duration
        
        cell.URLStringLabel.text = "Duration: \(audioDuration) seconds"
        cell.dateLabel.text = audioDate
        
        return cell
    }
    
    //plays audio when cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true) //deselects row
        
        let currentCell = tableView.cellForRow(at: indexPath) as! AudioCell
        currentCell.activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            currentCell.activityIndicator.stopAnimating()
        }
        
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
            let audioToDelete = audioFiles[indexPath.row]
            AudioService.removeAudio(audio: audioToDelete)
            AudioService.getAllAudios(for: User.current) { (audioFiles) in
                self.audioFiles = audioFiles
                self.tableView.reloadData()
            }
        }
    }
}

