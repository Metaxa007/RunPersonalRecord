import Foundation
import CoreLocation
import UIKit
import CoreData

struct CoreDataManager {
    static let manager = CoreDataManager()
    
    let locationEntity = "LocationEntity"
    
    func saveLocation(location: CLLocation) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: locationEntity, in: context) else {return}
        
        let coordinates = location.coordinate
        
        let taskObject = LocationEntity(entity: entity, insertInto: context)
        taskObject.latitude = coordinates.latitude
        taskObject.longitude = coordinates.longitude
        
        do {
            //            print("saved location")
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getLocations() -> [CLLocation] {
        var locations: [LocationEntity] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LocationEntity> = LocationEntity.fetchRequest()
        
        do {
            try locations = context.fetch(fetchRequest)
            print("location = \(locations.capacity)")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return locationEntityToCLLocation(locations: locations)
    }
    
    func locationEntityToCLLocation (locations:[LocationEntity]) -> [CLLocation] {
        var locationsCL: [CLLocation] = []

        for location in locations {
            locationsCL.append(CLLocation(latitude: location.latitude, longitude: location.longitude))
        }
        
        return locationsCL
    }
}
