//
//  ActivityEntity+CoreDataProperties.swift
//  RunPersonalRecord
//
//  Created by Artsem Lemiasheuski on 21.05.20.
//  Copyright © 2020 metaxa.RunPersonalRecord. All rights reserved.
//
//

import Foundation
import CoreData


extension ActivityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityEntity> {
        return NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
    }

    @NSManaged public var activityAttribute: Activity

}
