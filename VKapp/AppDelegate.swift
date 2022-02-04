//
//  AppDelegate.swift
//  VKapp
//
//  Created by MacBook on 25.11.2021.
//
import RealmSwift
import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
/*
        let realm = try! Realm()

        let charcher = TestModelRealm()
        charcher.id = 2
        charcher.name = "dfcs"
        charcher.age = 5
        
        let photo1 = ArrayUrlPhotos()
        photo1.sizes = "q/55"
        
        let photo2 = ArrayUrlPhotos()
        photo2.sizes = "a/66"
        
        let photos = Person()
        photos.ownerId = charcher
        photos.dogs.append(objectsIn: [photo1, photo2])

//        try! realm.write {
//            realm.add(charcher, update: .modified)
//        }
//        try! realm.write {
//            realm.add(photos)
//        }

 
//        let persons = realm.objects(Person.self)
//        print(persons[0].ownerId?.id ?? 0 )
//        print(realm.configuration.fileURL!)
//        try! realm.write {
//            // set each person's planet property to "Earth"
//            print(persons[0].dogs.count)
////            persons[0].dogs.removeAll()
//            persons[0].dogs[0].sizes = "324"
//            persons[0].dogs[1].sizes = "234"
//
//        }
        let persons = realm.objects(ArrayUrlPhotos.self)
        try! realm.write {
            realm.delete(persons)
//            realm.deleteAll()
        }
 */
        return true
    }
    
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VKapp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

