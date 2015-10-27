//
//  SongCellTableViewCell.swift
//  SimpleMusicPlayer
//
//  Created by Kamal on 10/26/15.
//  Copyright (c) 2015 AbstractApps. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var song:String!{
        didSet{
            songName.text = song.lastPathComponent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func playSong(sender: AnyObject) {
    }
    @IBAction func stopSong(sender: AnyObject) {
    }
    @IBAction func pauseSong(sender: AnyObject) {
    }
}