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
    var audioPlayer: AVAudioPlayer!
    
    var avPlayer: AVPlayer? //here
    var avPlayerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        AudioService.getAllAudios(for: User.current) { (audioFiles) in
            self.audioFiles = audioFiles
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
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
        let audioDownloadURLString = audio.audioURLString
        let audioDate = audio.date
        
        cell.URLStringLabel.text = audioDownloadURLString
        cell.dateLabel.text = audioDate
        
        return cell
    }
    
    //plays audio when cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as! AudioCell
        
        let audio = audioFiles[indexPath.row]
        let audioDownloadURLString = audio.audioURLString
        
        
        
        if let audioDownloadURL = URL(string: audioDownloadURLString) {

//            let protectionSpace = URLProtectionSpace.init(host: host,
//                                                          port: port,
//                                                          protocol: "http",
//                                                          realm: nil,
//                                                          authenticationMethod: nil)
//
//            var credential: URLCredential? = URLCredentialStorage.shared.defaultCredential(for: protectionSpace)
//
//            let userCredential = URLCredential(user: user,
//                                               password: password,
//                                               persistence: .permanent)
//
//            URLCredentialStorage.shared.setDefaultCredential(userCredential, for: protectionSpace)
            
            avPlayerItem = AVPlayerItem.init(url: audioDownloadURL)
            avPlayer = AVPlayer.init(playerItem: avPlayerItem)
            avPlayer?.volume = 1.0
            avPlayer?.play()
        }
        
//        if let audioUrl = URL(string: audioDownloadURLString) {
//
//            // then lets create your document folder url
//            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//            // lets create your destination file url
//            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//            // to check if it exists before downloading it
//            if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                print("The file already exists at path")
//                do {
//                    audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
//                    audioPlayer.prepareToPlay()
//                    print("PLAYING SELECTED URL: \(destinationUrl)")
//                    audioPlayer.play()
//                } catch let error {
//                    print("Error playing audio: \(error.localizedDescription)")
//                }
//                // if the file doesn't exist
//            }
//            else {
//                // you can use NSURLSession.sharedSession to download the data asynchronously
//                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
//                    guard let location = location, error == nil else { return }
//                    do {
//                        // after downloading your file you need to move it to your destination url
//                        try FileManager.default.moveItem(at: location, to: destinationUrl)
//                        print("File moved to documents folder")
//                    } catch let error as NSError {
//                        print(error.localizedDescription)
//                    }
//                    do {
//                        self.audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
//                        self.audioPlayer.prepareToPlay()
//                        print("PLAYING SELECTED URL: \(destinationUrl)")
//                        self.audioPlayer.play()
//                    } catch let error {
//                        print("Error playing audio: \(error.localizedDescription)")
//                    }
//                }).resume()
//            }
//        }
    }
}

