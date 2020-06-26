import Foundation
import CoreLocation
import UIKit
import CoreData

struct CoreDataManager {
    static let manager = CoreDataManager()
    
    let entityName = "ActivityEntity"
    
    private init(){}
    
    func addEntity(activity: Activity, pace: Pace, date: Date, duration: Double, distance: Int, completed: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext

            do {
                let activityEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ActivityEntity
                activityEntity.activityAttribute = activity
                activityEntity.date = date
                activityEntity.duration = duration
                activityEntity.distance = Int32(distance)
                activityEntity.completed = completed
                activityEntity.pace = pace
                
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
