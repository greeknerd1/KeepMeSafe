//
//  ViewController.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/24/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sliderLabel: UISlider!
    @IBOutlet weak var startLabel: UIButton!
    @IBOutlet weak var cancelLabel: UIButton!
    @IBOutlet weak var playLabel: UIButton!
    @IBOutlet weak var switchLabel: UISwitch!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var seconds = 60
    var timer = Timer()
    var alarmAudioPlayer = AVAudioPlayer()
    
    //AUDIO RECORDING CODE
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cancelLabel.isEnabled = false
        cancelLabel.tintColor = UIColor.darkGray
        
        recordingLabel.textColor = UIColor.red
        recordingLabel.text = "Not Recording"
        
        //AUDIO RECORDING CODE
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayAndRecord in HomeViewController.viewDidLoad() failed.")
        }

        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("access to mic GRANTED")
            }
            else {
                print("access to mic NOT GRANTED")
            }
        }
        
        do {
            let alarmAudioPath = Bundle.main.path(forResource: "alarm", ofType: ".mp3")
            try alarmAudioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: alarmAudioPath!))
        }
        catch {
            print("Error playing alarm audio")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if (audioPlayer != nil) {
            audioPlayer.stop()
            playLabel.setTitle("Play Recording", for: .normal)
        }
    }
    
    //AUDIO RECORDING CODE
    func getDocumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    //AUDIO RECORDING CODE
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action: UIAlertAction) in
            if (self.alarmAudioPlayer.isPlaying) {
                self.alarmAudioPlayer.stop()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
        seconds = Int(sender.value)
        timeLabel.text = String(seconds) + " seconds"
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeViewController.counter), userInfo: nil, repeats: true)
        
        recordingLabel.textColor = UIColor.green
        recordingLabel.text = "Recording"
        
        cancelLabel.tintColor = startLabel.tintColor
        startLabel.tintColor = UIColor.darkGray
        
        sliderLabel.isEnabled = false
        startLabel.isEnabled = false
        cancelLabel.isEnabled = true
        
        if (audioPlayer != nil && audioPlayer.isPlaying) { //if play recording is pressed, stops current recording that's playing
            audioPlayer.stop()
            playLabel.setTitle("Play recording", for: .normal)
        }
        
        //AUDIO RECORDING CODE
        if audioRecorder == nil { //checks if we have an active recorder
            let fileName = getDocumentDirectory().appendingPathComponent(".mp3")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            do { //starts audio recording
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
            }
            catch {
                displayAlert(title: "Uh Oh!", message: "Recording failed :(")
            }
        }
    }
    
    @objc func counter() {
        
        if (seconds == 0) {
            timer.invalidate()
            seconds = Int(sliderLabel.value)
            timeLabel.text = String(seconds) + " seconds"
            
            recordingLabel.textColor = UIColor.red
            recordingLabel.text = "Not Recording"
            
            if (switchLabel.isOn) {
                alarmAudioPlayer.play()
            }
            
            startLabel.tintColor = cancelLabel.tintColor
            cancelLabel.tintColor = UIColor.darkGray
            
            //AUDIO RECORDING CODE
            if (audioRecorder != nil) { //Stopping audio recording
                audioRecorder.stop()
                audioRecorder = nil
                
                //TESTING
                let audioURL = getDocumentDirectory().appendingPathComponent(".mp3")
                
                //*******NEW CODE*******
                // get the current date and time
                let currentDateTime = Date()
                
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .long
                
                // get the date time String from the date object
                let timestamp = formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
                
                var duration = "0:00"
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                    duration = String(Double(round(audioPlayer.duration*100)/100))
                }
                catch {
                    print("Error finding the time of recorder")
                }
                AudioService.create(audioURL: audioURL, date: timestamp, duration: duration)
            }
            
            sliderLabel.isEnabled = true
            startLabel.isEnabled = true
            cancelLabel.isEnabled = false
            
            //implement sending text message to contacts***********************
            displayAlert(title: "Emergency Message Sent!", message: "Audio Recording Saved!")
            return
        }
        
        seconds -= 1
        timeLabel.text = String(seconds) + " seconds"
        
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        timer.invalidate()
        seconds = Int(sliderLabel.value)
        timeLabel.text = String(seconds) + " seconds"
        
        recordingLabel.textColor = UIColor.red
        recordingLabel.text = "Not Recording"
        
        if (alarmAudioPlayer.isPlaying) {
            alarmAudioPlayer.stop()
        }
        
        startLabel.tintColor = cancelLabel.tintColor
        cancelLabel.tintColor = UIColor.darkGray
        
        sliderLabel.isEnabled = true
        startLabel.isEnabled = true
        cancelLabel.isEnabled = false
        
        //AUDIO RECORDING CODE
        if (audioRecorder != nil) { //Stopping audio recording
            audioRecorder.stop()
            audioRecorder = nil
            
            //TESTING
            let audioURL = getDocumentDirectory().appendingPathComponent(".mp3")
            
            //*******NEW CODE*******
            // get the current date and time
            let currentDateTime = Date()
            
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            // get the date time String from the date object
            let timestamp = formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
            
            var duration = "0:00"
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                duration = String(Double(round(audioPlayer.duration*100)/100))
            }
            catch {
                print("Error finding the time of recorder")
            }
            AudioService.create(audioURL: audioURL, date: timestamp, duration: duration)
        }
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        //AUDIO RECORDING CODE
        
        if (audioPlayer != nil && audioPlayer.isPlaying) { //stops recording and changes from stop to play
            audioPlayer.stop()
            playLabel.setTitle("Play Recording", for: .normal)
        }
        else if (audioRecorder == nil) { //plays recording and changes from play to stop
            let path = getDocumentDirectory().appendingPathComponent(".mp3")
        
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer.play()
                audioPlayer.delegate = self
                playLabel.setTitle("Stop Recording", for: .normal)
            }
            catch {
                print("Error playing the recording!")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playLabel.setTitle("Play recording", for: .normal)
    }
    
}

