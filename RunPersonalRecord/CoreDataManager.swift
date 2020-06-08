import Foundation
import CoreLocation
import UIKit
import CoreData

struct CoreDataManager {
    static let manager = CoreDataManager()
    
    let entityName = "ActivityEntity"
    
    private init(){}
    
    func addEntity(activity: Activity, date: Date, duration: Double, distance: Double) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                let activityEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ActivityEntity
                activityEntity.activityAttribute = activity
                activityEntity.date = date
                activityEntity.duration = duration
                activityEntity.distance = distance
                
                try context.save()
            } catch {
                fatalError()
            }
        }
    }
    
    func getAllEntities() -> [ActivityEntity]? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                let fetchRequest = NSFetchRequest<ActivityEntity>(entityName: entityName)
                let results = try context.fetch(fetchRequest)
                
                return results
            } catch {
                fatalError()
            }
        }
        
        return nil
    }
    
    func deleteActivity(activity: ActivityEntity) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                context.delete(activity)
                
                try context.save()
            } catch {
                fatalError()
            }
        }
    }
    
    func deleteAll() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                let fetchRequest = NSFetchRequest<ActivityEntity>(entityName: entityName)
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    context.delete(result)
                }
                
                try context.save()
            } catch {
                fatalError()
            }
        }
    }
}
//    func saveLocation(location: CLLocation) {
//        let context = getContext()
//
//        guard let entity = NSEntityDescription.entity(forEntityName: locationEntity, in: context) else {return}
//
//        let coordinates = location.coordinate
//
//        let taskObject = LocationEntity(entity: entity, insertInto: context)
//        taskObject.latitude = coordinates.latitude
//        taskObject.longitude = coordinates.longitude
//
//        do {
//            //            print("saved location")
//            try context.save()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//    }
//
//    func getLocations() -> [CLLocation] {
//        var locations: [LocationEntity] = []
//        let context = getContext()
//
//        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
//
//        do {
//            try locations = context.fetch(fetchRequest)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//
//        print("Tag1 count = \(locations.count)")
//
//        return locationEntityToCLLocation(locations: locations)
//    }
//
//    func locationEntityToCLLocation (locations:[LocationEntity]) -> [CLLocation] {
//        var locationsCL: [CLLocation] = []
//
//        for location in locations {
//            locationsCL.append(CLLocation(latitude: location.latitude, longitude: location.longitude))
//        }
//
//        return locationsCL
//    }
//
//
//    private func getContext() -> NSManagedObjectContext {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer.viewContext
//    }
//}
//    func retrieveUser() -> NSManagedObject? {
//        let managedContext = getContext()
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//
//        do {
//            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
//            if result.count > 0 {
//                // Assuming there will only ever be one User in the app.
//                return result[0]
//            } else {
//                return nil
//            }
//        } catch let error as NSError {
//            print("Retrieiving user failed. \(error): \(error.userInfo)")
//           return nil
//        }
//    }
//
//    func saveBook(_ book: Book) {
//        print(NSStringFromClass(type(of: book)))
//        let managedContext = getContext()
//        guard let user = retrieveUser() else { return }
//
//        var books: [Book] = []
//        if let pastBooks = user.value(forKey: "books") as? [Book] {
//            books += pastBooks
//        }
//        books.append(book)
//        user.setValue(books, forKey: "books")
//
//        do {
//            print("Saving session...")
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Failed to save session data! \(error): \(error.userInfo)")
//        }
//    }
//
//
//
//}

//extension CoreDataManager {
//    private lazy var userEntity: NSEntityDescription = {
//        let managedContext = getContext()
//        return NSEntityDescription.entity(forEntityName: "User", in: managedContext!)!
//    }()
//}
//
//extension CoreDataManager {
//    /// Creates a new user with fresh starting data.
//    func createUser() {
//        guard let managedContext = getContext() else { return }
//        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
//
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Failed to save new user! \(error): \(error.userInfo)")
//        }
//    }
//}
