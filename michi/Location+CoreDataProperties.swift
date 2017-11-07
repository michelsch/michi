//
//  Location+CoreDataProperties.swift
//  michi
//
//  Created by Michel Schoemaker on 6/5/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var name: String?
    @NSManaged var newRelationship: NSSet?

}
