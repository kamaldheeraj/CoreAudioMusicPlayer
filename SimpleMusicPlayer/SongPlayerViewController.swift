//
//  SongPlayerViewController.swift
//  SimpleMusicPlayer
//
//  Created by Navya Rayala on 10/26/15.
//  Copyright (c) 2015 AbstractApps. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class SongPlayerViewController: AVPlayerViewController{
    
    var songPath:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        player = AVPlayer(URL: NSURL(fileURLWithPath: songPath))
        player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
