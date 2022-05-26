//
//  TestUser+CoreDataProperties.swift
//  Meet_Test
//
//  Created by Apple iQlance on 25/05/2022.
//

import Foundation
import CoreData


extension TestUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestUser> {
        return NSFetchRequest<TestUser>(entityName: "TestUser")
    }

    @NSManaged public var name: String?
    @NSManaged public var company: String?
    @NSManaged public var followers: String?
    @NSManaged public var following: String?
    @NSManaged public var detail: String?
    @NSManaged public var blog: String?
    @NSManaged public var avatar_url: String?
    @NSManaged public var notes: String?
}
