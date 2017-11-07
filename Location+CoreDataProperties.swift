//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Michel Schoemaker on 6/5/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var language: String?
    @NSManaged var name: String?
    @NSManaged var newRelationship: NSSet?

}
