//
//  AppDelegate.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 07.11.21.
//

import UIKit
import UserNotifications
import SafariServices
import AVFoundation
import MediaPlayer
import FirebaseCore
//import CoreData


@main
class AppDelegate: UIResponder, UIApplicationDelegate{ //, MessagingDelegate
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //FirebaseApp.configure()
        FirebaseApp.configure()
        addAllSound()
        loundSound = UserDefaults.standard.bool(forKey: "loundSound")
        


        
        /*
         if UserDefaults.standard.integer(forKey: "thecount") == nil {
         UserDefaults.standard.set(0, forKey: "thecount")
         print("setted count")
         }else{
         print("already set")
         let count = UserDefaults.standard.integer(forKey: "thecount")
         print("count: \(count)")
         
         }*/


        
        return true
    }
    

    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //self.saveDatabase()
    }
    
    /*
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
      let container = NSPersistentCloudKitContainer(name: "UserInfo")
//        let description = container.persistentStoreDescriptions.first
//
//                description?.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.fku.WatchSoundboard")

        
//      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//        if let error = error as NSError? {
//          fatalError("Unresolved error \(error), \(error.userInfo)")
//        }
//      })
        container.loadPersistentStores(completionHandler: { (_, error) in
                    if let error = error as NSError? {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
      return container
    }()
    
    func saveDatabase () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }*/

}


