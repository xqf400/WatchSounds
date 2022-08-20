//
//  ViewController.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 07.11.21.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var volumeButtonOultet: UIBarButtonItem!
    @IBOutlet weak var collectionTopConstraint: NSLayoutConstraint!
    
    var soundArray: [SoundModel] = []
    
    let backGroundColor = UIColor.green
    let labelTextColor = UIColor.white
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionTopConstraint.constant = 0
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        collectionView.addGestureRecognizer(longPress)        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
        collectionView.collectionViewLayout = layout
        
        addAllSounds()
        if playAMessage {
            //showHudSuccess(inView: self, text: "play \(playSoundString)", delay: 2.0)
        }
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
        addAllSounds()
    }
    
    
    @IBAction func randomPlayButton(_ sender: Any) {
        let number = Int.random(in: 0..<soundArray.count)
        playSound(index: number)
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        if player != nil {
            player!.pause()
        }
        for row in 0..<collectionView.numberOfItems(inSection: 0){
            let indexPath = NSIndexPath(row:row, section:0)
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as? SoundViewCollectionViewCell
            cell?.backGroundView.backgroundColor = backGroundColor
        }
    }
    
    @IBAction func volumeButtonAction(_ sender: Any) {
        loundSound = !loundSound
        UserDefaults.standard.set(loundSound, forKey: "loundSound")
        if loundSound {
            volumeButtonOultet.image = UIImage(systemName: "volume.3")
            if TargetDevice.currentDevice != .nativeMac {
                print("loud")
                MPVolumeView.setVolume(1.0)
            }
        }else{
            volumeButtonOultet.image = UIImage(systemName: "volume")
        }
    }
    
    private func addAllSounds(){
        
        soundArray.removeAll()
        
        soundArray.append(Tag__kurz)
        soundArray.append(delfin)
        soundArray.append(excited_kurz)
        soundArray.append(excited_lang)
        soundArray.append(mimimi)
        soundArray.append(SchoenistesaufderWeltzusein)
        soundArray.append(SchoenerTagStuttgarter)
        soundArray.append(tellmewhylang)
        soundArray.append(tellmewhykurz)
        soundArray.append(gehdochzuhause)
        
        soundArray.append(Spass_lang_lang)
        soundArray.append(Tag__mittel)
        soundArray.append(Tag_lang)
        soundArray.append(alterFalter)
        soundArray.append(ichLiebeDich)
        soundArray.append(danngehdochzunetto)
        soundArray.append(imperialmarch)
        
        soundArray.append(denken)
        soundArray.append(Spass__kurz)
        soundArray.append(Spass__mittel)
        soundArray.append(JedeZelleKurz)
        soundArray.append(JedeZelleLang)
        soundArray.append(erlebtnochkurz)
        soundArray.append(erlebtnochlang)
        soundArray.append(jajalang)
        soundArray.append(jajakurz)
        soundArray.append(miracolikurz)
        soundArray.append(miracolilang)
        soundArray.append(OneMoreTime)
        soundArray.append(HitMeBabyOneMoreTime)
        soundArray.append(letsgo)
        soundArray.append(esel)
        soundArray.append(everbodydancenowlang)
        soundArray.append(ComputerSagtNein)
        soundArray.append(wasmachensachen)
        soundArray.append(BaDumTss)
        soundArray.append(Mallezuruck)
        soundArray.append(vielleichtsekt)
        soundArray.append(Iloveit)
        soundArray.append(IDontcare)
        soundArray.append(IloveitIDontcare)
        soundArray.append(everbodydancenowkurz)
        soundArray.append(everbodydancenowmittel)
        soundArray.append(lollipop_kurz)
        soundArray.append(lollipop_long)
        soundArray.append(lollipop1)
        soundArray.append(lollipop2)
        soundArray.append(lollipop_pop)
        soundArray.append(EsTutMirLeid)
        soundArray.append(EsTutMirLeidPocahontas)
        soundArray.append(IfYoureHappy)
        soundArray.append(IfYoureHappyClap)
        soundArray.append(VerstehIchNichtKurz)
        soundArray.append(VerstehIchNichtLang)
        soundArray.append(CantinaBand)
        soundArray.append(QuatschMerkschSelber)
        soundArray.append(imperialmarchLong)
        soundArray.append(Layla)
        
        soundArray = soundArray.sorted(by: { $0.soundName < $1.soundName })
        
        collectionView.reloadData()
    }
    
    func playSound(index: Int){
        
        guard let url = Bundle.main.url(forResource: soundArray[index].soundFile, withExtension: "mp3") else { return }
        let volume = soundArray[index].soundVolume
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.delegate = self
            player?.setVolume(volume, fadeDuration: 10.0)
            //guard let player = player else { return }
            player!.play() 
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc private func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: collectionView)
            if let indexPath = self.collectionView.indexPathForItem(at: touchPoint) {
                let song = soundArray[indexPath.row]
                print("Name:", song.soundName)
                /*
                 var foundSong = false
                 for sound in favSoundsArray {
                 if sound.soundFile == song.soundFile {
                 foundSong = true
                 let index1 = favSoundsArray.firstIndex{$0 === song}
                 if index1 != nil {
                 favSoundsArray.remove(at: index1!)
                 }
                 }
                 }
                 if !foundSong {*/
                favSoundsArray.append(song)
                showHudSuccess(inView: self, text: "\(song.soundName) zu Favoriten hinzugefügt", delay: 1.0)
                //}
                
                saveFavoritesLocal()
            } else {
                print("couldn't find index path")
            }
        }
    }
    
    
}//eoc

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SoundViewCollectionViewCell
        cell.cellImageView.image = UIImage(named: soundArray[indexPath.row].soundImage)?.roundedImage
        cell.backGroundView.backgroundColor = backGroundColor
        //cell.cellImageView.layer.masksToBounds = true
        //cell.cellImageView.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.cellLabel.textColor = .black
        cell.cellLabel.text = soundArray[indexPath.row].soundName
        guard let url = Bundle.main.url(forResource: soundArray[indexPath.row].soundFile, withExtension: "mp3") else {
            print("File not found: \(soundArray[indexPath.row].soundFile)")
            return cell}
        
        let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: url, options: nil).duration)
        let seconds = String(format: "%.1fs", audioDurationSeconds)
        
        let str = NSMutableAttributedString(string: "\(soundArray[indexPath.row].soundName): \(seconds)", attributes: nil)
        let length = str.length
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: NSRange(location:length-5,length:5))
        
        //cell.cellLabel.text = "\(soundArray[indexPath.row].soundName): \(seconds)"
        //cell.cellLabel.textColor = labelTextColor
        cell.cellLabel.attributedText = str
        if soundArray[indexPath.row].soundName.contains("Lollipop") {
            cell.cellImageView.rotate()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return soundArray.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playSound(index: indexPath.row)
        for row in 0..<collectionView.numberOfItems(inSection: 0){
            let indexPath = NSIndexPath(row:row, section:0)
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as? SoundViewCollectionViewCell
            cell?.backGroundView.backgroundColor = backGroundColor
        }
        let cell = collectionView.cellForItem(at: indexPath) as! SoundViewCollectionViewCell
        cell.backGroundView.backgroundColor = .red
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = 110
        if UIDevice.current.userInterfaceIdiom == .pad {
            size = 160
        }
        return CGSize(width: size, height: size)
    }
}



extension ViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            for row in 0..<collectionView.numberOfItems(inSection: 0){
                let indexPath = NSIndexPath(row:row, section:0)
                
                let cell = collectionView.cellForItem(at: indexPath as IndexPath) as? SoundViewCollectionViewCell
                cell?.backGroundView.backgroundColor = backGroundColor
            }
        }
    }
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}


extension UIImage{
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 50
        ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
