//
//  ActivityEntity+CoreDataProperties.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 11.06.20.
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
    @NSManaged public var date: Date?
    @NSManaged public var distance: Double
    @NSManaged public var duration: Double
    @NSManaged public var completed: Bool

}
