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

class FavViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    @IBOutlet weak var volumeButtonOultet: UIBarButtonItem!
    let backGroundColor = UIColor.yellow
    let labelTextColor = UIColor.white
    var grantedObserver :Void?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionViewTopConstraint.constant = 0
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
        grantedObserver = NotificationCenter.default.addObserver(self, selector: #selector(grantedFunc), name: Notification.Name("grantedObserver"), object: nil)
        
        addAllSounds()
        
        
    }
    
    @objc func grantedFunc(){
        DispatchQueue.main.async {
            self.addAllSounds()
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
        //let count = UserDefaults.standard.integer(forKey: "thecount")
        //navBarTitle.title = "Favoriten \(count)"
    }
    
    
    @IBAction func shuffleAction(_ sender: Any) {
        let number = Int.random(in: 0..<favSoundsArray.count)
        playSound(index: number)
    }
    
    @IBAction func stopAction(_ sender: Any) {
        if player != nil {
            player!.pause()
        }
        for row in 0..<collectionView.numberOfItems(inSection: 0){
            let indexPath = NSIndexPath(row:row, section:0)
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as? SoundViewCollectionViewCell
            cell?.backGroundView.backgroundColor = backGroundColor
        }
    }
    @IBAction func supportAction(_ sender: Any) {
        //showSupportAlert()
        showSupportMSENLU()
    }
    
    private func showSupportMSENLU(){
        let alert = UIAlertController(title: "Support", message: "Damit wir Ihre Anliegen schnell bearbeiten können stellen wir Ihnen mehrere Anlaufstellen zur Verfügung.", preferredStyle: UIAlertController.Style.alert )
        let support1Action = UIAlertAction(title: "Supportmitarbeiter 1", style: .default) { _ in
            self.sentMailTo(mail: "mse@kuk-is.de")
        }
        let support2Action = UIAlertAction(title: "Supportmitarbeiter 2", style: .default) { _ in
            self.sentMailTo(mail: "nlu@kuk-is.de")
        }
        let support3Action = UIAlertAction(title: "Supportmitarbeiter 3", style: .destructive) { _ in
            guard let url = Bundle.main.url(forResource: "lollipop_kurz", withExtension: "mp3") else { return }
            let volume = 1.0
            if TargetDevice.currentDevice != .nativeMac {
                //MPVolumeView.setVolume(1.0)
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player?.delegate = self
                player?.setVolume(Float(volume), fadeDuration: 10.0)
                player!.play()
            } catch let error {
                print(error.localizedDescription)
            }
            showHudError(inView: self, text: "Dieser Mitarbeiter ist zur Zeit nicht verfügbar. Bitte wählen Sie einen anderer Mitarbeiter aus. Diese helfen Ihnen gerne weiter", delay: 3.0)
        }
        let cancelAction = UIAlertAction(title: "Benötige kein Support", style: .cancel) { _ in
        }
        alert.addAction(support1Action)
        alert.addAction(support2Action)
        alert.addAction(support3Action)
        alert.addAction(cancelAction)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: Send Mail
    private func sentMailTo(mail: String){
        let email = mail
        let emailSubject = "Soundboard Anliegen"
        let emailBody = ""
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([email])
            mailComposerVC.setSubject(emailSubject)
            mailComposerVC.setMessageBody(emailBody, isHTML: true)
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            let coded = "mailto:\(email)?subject=\(emailSubject)&body=\(emailBody)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded!)
            {
                if UIApplication.shared.canOpenURL(emailURL)
                {
                    UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                        if !result {
                            showHudError(inView: self, text: "Keine Mail konfiguriert", delay: 2.0)
                        }
                    })
                }
            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print(result.rawValue)
        controller.dismiss(animated: true, completion: nil)
        if result.rawValue > 0 {
            showHudSuccess(inView: self, text: "E-Mail versendet", delay: 2.0)
        }else{
            guard let url = Bundle.main.url(forResource: "lollipop_kurz", withExtension: "mp3") else { return }
            let volume = 1.0
            if TargetDevice.currentDevice != .nativeMac {
                //MPVolumeView.setVolume(1.0)
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player?.delegate = self
                player?.setVolume(Float(volume), fadeDuration: 10.0)
                player!.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func showSupportAlert(){
        guard let url = Bundle.main.url(forResource: "lollipop_kurz", withExtension: "mp3") else { return }
        let volume = 1.0
        let alert = UIAlertController(title: "Support", message: "Um zum Support zu benachrichtigen und kontaktieren klicken Sie bitte auf \"Support\".", preferredStyle: UIAlertController.Style.alert )
        let supportAction = UIAlertAction(title: "Support", style: .destructive) { _ in
            if TargetDevice.currentDevice != .nativeMac {
                MPVolumeView.setVolume(1.0)
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player?.delegate = self
                player?.setVolume(Float(volume), fadeDuration: 10.0)
                player!.play()
            } catch let error {
                print(error.localizedDescription)
            }
            self.showSupportAlert()
        }
        alert.addAction(supportAction)
        present(alert,animated: true, completion: nil)
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
    private func addAllSounds(){
        
        favSoundsArray.removeAll()
        if messagesAreAllowed {
            getFavsLocal()
            collectionView.reloadData()
            if favSoundsArray.count == 0 {
                let alert = UIAlertController(title: nil, message: "Keine Favoriten bis jetzt. Um Favoriten hinzuzufügen halten Sie Ihre Lieblingssounds gedrückt, damit sie hinzugefügt werden.", preferredStyle: UIAlertController.Style.alert )
                let cancelAction = UIAlertAction(title: "Verstanden", style: .destructive, handler: nil)
                alert.addAction(cancelAction)
                present(alert,animated: true, completion: nil)
            }
        }else{
            showHudError(inView: self, text: "Benachrichtigungen sind deaktiviert. Bitte zuerst aktivieren!", delay: 2.0)
        }
        
    }
    
    func playSound(index: Int){
        
        if favSoundsArray[index].soundFile == "fku_Konsultant"{
            var textField = UITextField()
            
            let alert = UIAlertController(title: "AKonsultant abspielen?", message: "Bitte Passwort eingeben", preferredStyle: UIAlertController.Style.alert )
            let cancelAction = UIAlertAction(title: "Abbrechen", style: .destructive, handler: nil)
            let okAction = UIAlertAction(title: "Absenden", style: .default) { (action) in
                if textField.text == "2707"  {
                    guard let url = Bundle.main.url(forResource: favSoundsArray[index].soundFile, withExtension: "mp3") else { return }
                    let volume = favSoundsArray[index].soundVolume
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
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Passwort"
                alertTextField.keyboardType = .decimalPad
                alertTextField.isSecureTextEntry = true
                textField = alertTextField
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert,animated: true, completion: nil)
        }else{
            guard let url = Bundle.main.url(forResource: favSoundsArray[index].soundFile, withExtension: "mp3") else { return }
            let volume = favSoundsArray[index].soundVolume
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
    }
    @objc private func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: collectionView)
            if let indexPath = self.collectionView.indexPathForItem(at: touchPoint) {
                let song = favSoundsArray[indexPath.row]
                let index1 = favSoundsArray.firstIndex{$0 === song}
                if index1 != nil {
                    favSoundsArray.remove(at: index1!)
                    print("removed")
                    showHudSuccess(inView: self, text: "\(song.soundName) entfernt", delay: 1.0)
                }
                saveFavoritesLocal()
                collectionView.reloadData()
            } else {
                print("couldn't find index path")
            }
        }
    }
    
}//eoc


extension FavViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SoundViewCollectionViewCell
        if favSoundsArray[indexPath.row].soundImage.contains("gif"){
            let endIndex = favSoundsArray[indexPath.row].soundImage.index(favSoundsArray[indexPath.row].soundImage.endIndex, offsetBy: -4)
            let imageName = favSoundsArray[indexPath.row].soundImage.substring(to: endIndex)
            cell.cellImageView.image = UIImage.gifImageWithName(imageName)
            cell.cellImageView.layer.cornerRadius = 30
            cell.cellImageView.clipsToBounds = true
        }else{
            if favSoundsArray[indexPath.row].soundImage.contains("nils"){
                //cell.cellImageView.image = UIImage(named: nluImageNames.randomElement()!)
            }else{
                cell.cellImageView.image = UIImage(named: favSoundsArray[indexPath.row].soundImage)?.roundedImage
            }
        }
        cell.backGroundView.backgroundColor = backGroundColor
        //cell.cellImageView.layer.masksToBounds = true
        //cell.cellImageView.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.cellLabel.textColor = .black
        cell.cellLabel.text = favSoundsArray[indexPath.row].soundName
        guard let url = Bundle.main.url(forResource: favSoundsArray[indexPath.row].soundFile, withExtension: "mp3") else {
            print("File not found: \(favSoundsArray[indexPath.row].soundFile)")
            return cell}
        
        let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: url, options: nil).duration)
        let seconds = String(format: "%.1fs", audioDurationSeconds)
        
        let str = NSMutableAttributedString(string: "\(favSoundsArray[indexPath.row].soundName): \(seconds)", attributes: nil)
        let length = str.length
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSRange(location:length-5,length:5))
        
        //cell.cellLabel.text = "\(soundArray[indexPath.row].soundName): \(seconds)"
        //cell.cellLabel.textColor = labelTextColor
        cell.cellLabel.attributedText = str
        
        
        
        if favSoundsArray[indexPath.row].soundName.contains("Lollipop") {
            cell.cellImageView.rotate()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return favSoundsArray.count
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



extension FavViewController: AVAudioPlayerDelegate {
    
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

