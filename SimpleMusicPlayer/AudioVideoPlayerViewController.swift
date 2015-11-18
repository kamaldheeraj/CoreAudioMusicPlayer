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
                        //println(audioImage.description)
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
        
        //AVPlayer to play song/video
        player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: songPath), error: nil)
        //player = AVAudioPlayer(URL: NSURL(fileURLWithPath: songPath))
        
        //AVPlayerLayer to place video in view
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = CGRect(x: 40, y: 50, width: view.frame.size.width-40, height: view.frame.size.height-95)
//        view.layer.addSublayer(playerLayer)
        
        avAsset = AVURLAsset(URL: NSURL(fileURLWithPath: songPath)!, options: nil)
        slider.maximumValue = Float(CMTimeGetSeconds(avAsset!.duration))
            
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
    
//    func playingDone( notification: NSNotification  ){
//        println("Done Playing")
//    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        player.stop()
    }

 
    @IBAction func playPausePressed(sender: AnyObject) {
        if player.rate>0{
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
        //player.seekToTime(CMTimeMake(Int64(slider.value), 1))
        //playPausePressed(sender)
    }
    
    //Reference: https://www.youtube.com/watch?v=S3BSK8UVJyc
    func moveSlider(){
        //slider.value = Float(CMTimeGetSeconds(player.currentTime()))
        slider.value = Float(player.currentTime)
    }
    
    func changeTime(){
        //let timeCurrent = Int(round(CMTimeGetSeconds(player.currentTime())))
        let timeCurrent = Int(round(player.currentTime))
        let timeTotal = Int(round(CMTimeGetSeconds(avAsset!.duration)))
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
        //player.seekToTime(CMTimeMake(0, 1))
        myPlay()
    }
}
