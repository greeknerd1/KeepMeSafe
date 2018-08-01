//
//  ViewController.swift
//  KeepMeSafe
//
//  Created by Gabriel Khouri-Haddad on 7/24/18.
//  Copyright © 2018 Gabriel Khouri-Haddad. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sliderLabel: UISlider!
    @IBOutlet weak var startLabel: UIButton!
    @IBOutlet weak var cancelLabel: UIButton!
    
    var seconds = 60
    var timer = Timer()
    var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cancelLabel.isEnabled = false
        cancelLabel.tintColor = UIColor.darkGray
        
        do {
            let audioPath = Bundle.main.path(forResource: "alarm", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch {
            print("Error playing alarm audio")
        }
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
        
        cancelLabel.tintColor = startLabel.tintColor
        startLabel.tintColor = UIColor.darkGray
        
        sliderLabel.isEnabled = false
        startLabel.isEnabled = false
        cancelLabel.isEnabled = true
    }
    
    @objc func counter() {
        
        if (seconds == 0) {
            timer.invalidate()
            //implement sending text message and location to contacts and showing up a notification (like alarm) here to call 911... may have to re-enable cancel button or something
            audioPlayer.play()
            return
        }
        
        if(seconds == 10 || seconds == 9 || seconds == 8 || seconds == 7 || seconds == 6 || seconds == 5 || seconds == 4 || seconds == 3 || seconds == 2 || seconds == 1) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
        seconds -= 1
        timeLabel.text = String(seconds) + " seconds"
        
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        timer.invalidate()
        seconds = Int(sliderLabel.value)
        timeLabel.text = String(seconds) + " seconds"
        
        audioPlayer.stop()
        
        startLabel.tintColor = cancelLabel.tintColor
        cancelLabel.tintColor = UIColor.darkGray
        
        sliderLabel.isEnabled = true
        startLabel.isEnabled = true
        cancelLabel.isEnabled = false
    }
}

