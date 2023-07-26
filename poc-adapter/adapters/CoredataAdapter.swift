//
//  CoredataAdapter.swift
//  poc-adapter
//
//  Created by carlos amorim on 25/07/23.
//

import Foundation
import CoreData

class CoredataAdapter: DatabaseAdapter {
    
    var list: [ElementAdapter] = []
    let viewContext = PersistenceController.shared.container.viewContext
    private var internalContolerList: [User] = []
    
    static var instance: any DatabaseAdapter = CoredataAdapter()
    
    init(){
        fetch()
    }
    
    func fetch() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let myEntititesRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let users =   NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let entities = try viewContext.fetch(myEntititesRequest)
            let users = try viewContext.fetch(users)
        } catch {
        }
        guard let fetchedUsers = try? viewContext.fetch(fetchRequest) else {
            return
        }
        internalContolerList = fetchedUsers
        list = []
        fetchedUsers.forEach { users in
            guard let id = Int("\(users.id)"), let email = users.email, let password = users.password else { return }
            list.append(ElementAdapter(id: id, email: email, password: password))
        }
    }
    
    func createElement(email: String, password: String) -> ElementAdapter? {
        let newUser = User(context: viewContext)
        newUser.id = Int16(Int.random(in: 1...1000))
        newUser.email = email
        newUser.password = password
        do {
            try viewContext.save()
            fetch()
            guard let id = Int("\(newUser.id)"), let email = newUser.email, let password = newUser.password else { return nil }
            return ElementAdapter(id: id, email: email, password: password)
        } catch let error as NSError {
            print("could not save \(error) \(error.userInfo)")
            return nil
        }
    }
    
    func deleteElement(id: Int) -> Bool {
        guard let elementSelected: User = internalContolerList.filter({ element in return element.id == id }).first else { return false }
        viewContext.delete(elementSelected)
        do {
            try viewContext.save()
            fetch()
            return true
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func updateElement(id: Int, newEmail: String, newPassword: String) {
        guard let elementSelected: User = internalContolerList.filter({ element in return element.id == id }).first else { return  }
        
        elementSelected.email = newEmail
        elementSelected.password = newPassword
        do {
            try viewContext.save()
            fetch()
        } catch let error as NSError {
            print("could not save \(error) \(error.userInfo)")
        }
    }
    
    
}
