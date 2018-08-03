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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let audioURLString = audio.audioURLString
        
        if let audioUrl = URL(string: audioURLString) {

            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                do {
                    var audioPlayer: AVAudioPlayer!
                    audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                    guard let player = audioPlayer else { return }
                    player.prepareToPlay()
                    print("PLAYING SELECTED URL: \(destinationUrl)")
                    player.play()
                } catch let error {
                    print("Error playing audio: \(error.localizedDescription)")
                }
                // if the file doesn't exist
            } else {
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    do {
                        var audioPlayer: AVAudioPlayer!
                        audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                        guard let player = audioPlayer else { return }
                        player.prepareToPlay()
                        print("PLAYING SELECTED URL: \(destinationUrl)")
                        player.play()
                    } catch let error {
                        print("Error playing audio: \(error.localizedDescription)")
                    }
                }).resume()
            }
        }
    }
}

