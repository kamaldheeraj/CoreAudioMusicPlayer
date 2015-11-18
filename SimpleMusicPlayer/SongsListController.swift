    //
    //  ViewController.swift
    //  SimpleMusicPlayer
    //
    //  Created by Kamal on 10/25/15.
    //  Copyright (c) 2015 AbstractApps. All rights reserved.
    //
    
    import UIKit
    class SongsListController: UITableViewController {
        var songs = [AnyObject]()
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            for bundle in NSBundle.allBundles(){
                var filePaths = bundle.pathsForResourcesOfType(nil, inDirectory: nil)
            for file in filePaths{
                if(file.pathExtension=="mp3" || file.pathExtension=="m4a"){
                    songs.append(file)
                }
            }
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return songs.count
        }
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as! UITableViewCell
            let song: (AnyObject) = songs[indexPath.row]
            cell.textLabel?.text = song.lastPathComponent
            return cell
        }
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "showDetail" {
                if let indexPath = self.tableView.indexPathForSelectedRow(){
                    ((segue.destinationViewController as! UINavigationController).childViewControllers[0] as!  AudioVideoPlayerViewController).songPath = songs[indexPath.row] as! String
                }
            }
        }
        @IBAction func donePlayingAV(segue:UIStoryboardSegue) {
        }
    }
