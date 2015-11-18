//
//  AudioVideoPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Navya Rayala on 10/27/15.
//  Copyright (c) 2015 AbstractApps. All rights reserved.
//

import UIKit
import AVFoundation
//import AVKit
class AudioVideoPlayerViewController: UIViewController {
    //var for UIImageView to display mp3 image created with a default image for mp3s with no images
    var mp3ImageView = UIImageView(image: UIImage(named: "Stock"))
    var sliderImage = UIImage(named: "sliderImage")
    
    var avAsset:AVAsset?
    
    var sliderTimer:NSTimer?
    var secondsTimer:NSTimer?
    
    @IBOutlet weak var timer: UILabel!
    
    @IBOutlet weak var songVideoLabel: UINavigationItem!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    var songPath:String!
    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondsTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "changeTime", userInfo: nil, repeats: true)
        //Start of Code to display mp3 images
        //Reference: http://stackoverflow.com/questions/30243658/displaying-artwork-for-mp3-file
        let playerItem = AVPlayerItem( URL: NSURL(fileURLWithPath: songPath))
        let metaDataList = playerItem.asset.metadata as! [AVMetadataItem]
        for metaData in metaDataList{
            if metaData.commonKey == nil{
                continue
            }
            if let key = metaData.commonKey, let value = metaData.value {
                if key == "artwork" {
                    if let audioImage = UIImage(data: value as! NSData) {
                        mp3ImageView.image = audioImage
                    }
                }
            }
        }
        mp3ImageView.frame = CGRect(x: 40, y: 50, width: view.frame.width-40, height: view.frame.height-95)
        mp3ImageView.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(mp3ImageView)
        //End of Code to display mp3 images
        
        slider.setThumbImage(sliderImage, forState: .Normal)
        
        songVideoLabel.title = songPath.lastPathComponent.stringByDeletingPathExtension
        
        //AVAudioPlayer to play song
        player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: songPath), error: nil)
        
        slider.maximumValue = Float(player.duration)
            
        sliderTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "moveSlider", userInfo: nil, repeats: true)
        
        //Calling function to start playing
        myPlay()

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        sliderTimer!.invalidate()
        secondsTimer!.invalidate()
        player.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        player.currentTime=0
        myPause()
    }

 
    @IBAction func playPausePressed(sender: AnyObject) {
        if player.playing{
        myPause()
        }
        else
        {
          myPlay()
        }
    }
    func myPlay(){
        player.play()
        playPauseButton.setImage(UIImage(named: "Pause"), forState: .Normal)
    }
    func myPause(){
        player.pause()
        playPauseButton.setImage(UIImage(named: "Play"), forState: .Normal)
    }
    
    @IBAction func sliderValueChange(sender: AnyObject) {
        player.currentTime=NSTimeInterval(slider.value)
        player.play()
    }
    
    //Reference: https://www.youtube.com/watch?v=S3BSK8UVJyc
    // Jared Davidson channel Youtube
    func moveSlider(){
        slider.value = Float(player.currentTime)
    }
    
    func changeTime(){
        let timeCurrent = Int(round(player.currentTime))
        let timeTotal = Int(round(player.duration))
        if (timeCurrent%60)<10 && (timeTotal%60)<10 {
        self.timer.text = "\(timeCurrent/60):0\(timeCurrent%60)/\(timeTotal/60):0\(timeTotal%60)"
        }
        else if (timeCurrent%60)<10 {
           self.timer.text = "\(timeCurrent/60):0\(timeCurrent%60)/\(timeTotal/60):\(timeTotal%60)"
        }
        else if (timeTotal%60)<10 {
            self.timer.text = "\(timeCurrent/60):\(timeCurrent%60)/\(timeTotal/60):0\(timeTotal%60)"
        }
        else{
            self.timer.text = "\(timeCurrent/60):\(timeCurrent%60)/\(timeTotal/60):\(timeTotal%60)"
        }
    }
    
    @IBAction func restartButtonPressed(sender: AnyObject) {
    player.currentTime=0
        myPlay()
    }
}
