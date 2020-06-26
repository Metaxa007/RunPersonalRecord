//
//  ActivityEntity+CoreDataProperties.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 26.06.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//
//

import Foundation
import CoreData


extension ActivityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityEntity> {
        return NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
    }

    @NSManaged public var activityAttribute: Activity?
    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var distance: Int32
    @NSManaged public var duration: Double
    @NSManaged public var pace: Pace?

}
