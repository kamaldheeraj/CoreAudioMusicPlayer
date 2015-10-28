//
//  AudioVideoPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Navya Rayala on 10/27/15.
//  Copyright (c) 2015 AbstractApps. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
class AudioVideoPlayerViewController: UIViewController {
    //var for UIImageView to display mp3 image created with a default image for mp3s with no images
    var mp3ImageView = UIImageView(image: UIImage(named: "Stock"))
    var sliderImage = UIImage(named: "sliderImage")
    
    var timer:NSTimer?
    
    @IBOutlet weak var songVideoLabel: UINavigationItem!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    var songPath:String!
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        player = AVPlayer(URL: NSURL(fileURLWithPath: songPath))
        
        //AVPlayerLayer to place video in view
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 40, y: 50, width: view.frame.size.width-40, height: view.frame.size.height-95)
        view.layer.addSublayer(playerLayer)
        
        let avAsset = AVURLAsset(URL: NSURL(fileURLWithPath: songPath)!, options: nil)
        slider.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
            
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "moveSlider", userInfo: nil, repeats: true)
        
        //Calling function to start playing
        myPlay()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "playingDone", name: AVPlayerItemDidPlayToEndTimeNotification, object: player)

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playingDone( notification: NSNotification  ){
        println("Done Playing")
    
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        player.seekToTime(kCMTimeZero)
        myPause()
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
        player.seekToTime(CMTimeMake(Int64(slider.value), 1))
        playPausePressed(sender)
    }
    
    //Reference: https://www.youtube.com/watch?v=S3BSK8UVJyc
    func moveSlider(){
        slider.value = Float(CMTimeGetSeconds(player.currentTime()))
    }
    
    @IBAction func restartButtonPressed(sender: AnyObject) {
    player.seekToTime(CMTimeMake(0, 1))
        myPlay()
    }
}
