//
//  User+CoreDataProperties.swift
//  poc-adapter
//
//  Created by carlos amorim on 25/07/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int16
    @NSManaged public var password: String?

}

extension User : Identifiable {

}
