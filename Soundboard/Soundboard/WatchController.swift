//
//  FavViewController.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 08.12.21.
//

import UIKit
import AVFoundation
import MediaPlayer
import MessageUI

class WatchController: UIViewController {
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBOutlet weak var volumeButtonOultet: UIBarButtonItem!
    let backGroundColor = UIColor.yellow
    let labelTextColor = UIColor.white
    var grantedObserver :Void?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        if loundSound {
            volumeButtonOultet.image = UIImage(systemName: "volume.3")
            if TargetDevice.currentDevice != .nativeMac {
                MPVolumeView.setVolume(1.0)
            }
        }else{
            volumeButtonOultet.image = UIImage(systemName: "volume")
        }
        
    }
    
    
    
    @IBAction func stopAction(_ sender: Any) {
        if player != nil {
            player!.pause()
        }

    }


    @IBAction func volumeButtonAction(_ sender: Any) {
        
        loundSound = !loundSound
        UserDefaults.standard.set(loundSound, forKey: "loundSound")
        if loundSound {
            volumeButtonOultet.image = UIImage(systemName: "volume.3")
            if TargetDevice.currentDevice != .nativeMac {
                MPVolumeView.setVolume(1.0)
            }
        }else{
            volumeButtonOultet.image = UIImage(systemName: "volume")
        }
    }

    
    
}//eoc


extension WatchController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {

        }
    }
}

