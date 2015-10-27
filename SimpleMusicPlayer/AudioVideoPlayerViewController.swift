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

    @IBOutlet var mp3Image: UIImageView!
    @IBOutlet weak var songLabel: UINavigationItem!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var songPath:String!
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http://stackoverflow.com/questions/30243658/displaying-artwork-for-mp3-file
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
                        mp3Image.image = audioImage
                    }
                }
            }
        }
        songLabel.title = songPath.lastPathComponent.stringByDeletingPathExtension
        player = AVPlayer(URL: NSURL(fileURLWithPath: songPath))
                //slider.maximumValue = player
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 15, y: 35, width: view.frame.size.width, height: view.frame.size.height-85)
        view.layer.addSublayer(playerLayer)
        myPlay()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        player.seekToTime(CMTimeMake(0, 1))
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
        //player.seekToTime(CMTimeMake(Int64(slider.value), 1))
        println( slider.value )
        myPlay()
    }
    @IBAction func restartButtonPressed(sender: AnyObject) {
    player.seekToTime(CMTimeMake(0, 1))
        myPlay()
    }
}
