//
//  databaseAdapter.swift
//  poc-adapter
//
//  Created by carlos amorim on 25/07/23.
//

import Foundation

protocol DatabaseAdapter: ObservableObject {
    var list: [ElementAdapter] { get }
    static var instance: any DatabaseAdapter { get }
    func fetch() -> Void
    func createElement(email: String, password: String) -> ElementAdapter?
    func deleteElement(id: Int) -> Bool
    func updateElement(id: Int, newEmail: String, newPassword: String)
}
