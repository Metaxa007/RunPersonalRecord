import Foundation
import CoreLocation
import UIKit
import CoreData

struct CoreDataManager {
    static let manager = CoreDataManager()
    
    let entityName = "ActivityEntity"
    
    private init(){}
    
    func addEntity(activity: Activity, date: Date, duration: Double, distance: Double, completed: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext

            let pace = [1.0:1.0, 2:2, 3:3]
            let paceObj = Pace.init(pace: pace)
            do {
                let activityEntity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ActivityEntity
                activityEntity.activityAttribute = activity
                activityEntity.date = date
                activityEntity.duration = duration
                activityEntity.distance = distance
                activityEntity.completed = completed
                activityEntity.pace = paceObj
                
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
