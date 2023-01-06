//
//  Test+CoreDataProperties.swift
//  TestPod3
//
//  Created by rolodestar on 2023/1/5.
//
//

import Foundation
import CoreData


extension Test {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Test> {
        return NSFetchRequest<Test>(entityName: "Test")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?

}

extension Test : Identifiable {

}
