//
//  FileManegerAdapter.swift
//  poc-adapter
//
//  Created by carlos amorim on 25/07/23.
//

import Foundation


private struct FileHelper {
    private let manager = FileManager.default
    
    func createDocument(named fileName: String, with data: Data)-> Bool {
        let documentURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentURL.appendingPathComponent(fileName)
        manager.createFile(atPath: url.path, contents: data)
        return manager.fileExists(atPath: url.path)
    }
    
    func readDocument(at path: String) -> Data? {
        let documentURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentURL.appendingPathComponent(path)
        return try? Data(contentsOf: url)
    }
}

class FileManegerAdapter: DatabaseAdapter {
    @Published var list: [ElementAdapter] = []
    static var instance: any DatabaseAdapter = FileManegerAdapter(fileName: "poc-adapter", fileNextIdName: "id_adapter")
    
    private var file: FileHelper
    private var encoder: JSONEncoder
    private var fileName: String
    private var fileNextIdName: String
    private var decoder: JSONDecoder
    
    init(fileName: String, fileNextIdName: String){
        self.file = FileHelper()
        self.encoder = JSONEncoder()
        self.fileName = fileName
        self.decoder = JSONDecoder()
        self.fileNextIdName = fileNextIdName
        fetch()
    }
    
    func fetch() {
        do {
            let manager = FileManager.default
            let documentURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentURL.appendingPathComponent(self.fileName)
            if(manager.fileExists(atPath: url.path)){
                var registersList = file.readDocument(at: self.fileName)!
                let regitersDecoded = try self.decoder.decode([ElementAdapter].self, from: registersList)
                list = regitersDecoded
            }
        }catch{
            print("Error")
        }
    }
    
    func createElement(email: String, password: String) -> ElementAdapter? {
        let newElement: ElementAdapter = ElementAdapter(id: Int.random(in: 1...1000000), email: email, password: password)
        list.append(newElement)
        do {
            let data = try self.encoder.encode(list)
            file.createDocument(named: self.fileName, with: data)
            return newElement
        } catch {
            return nil
        }
    }
    
    func deleteElement(id: Int) -> Bool {
        guard let elementSelected: ElementAdapter = list.filter({ element in return element.id == id }).first else { return false }
        list = list.filter({ element in return element.id != id })
        do {
            let data = try self.encoder.encode(list)
            file.createDocument(named: self.fileName, with: data)
            return true
        } catch {
            return false
        }
    }
    
    func updateElement(id: Int, newEmail: String, newPassword: String) {
        list = list.map { element in
            if (element.id == id){
                return ElementAdapter(id: element.id, email: newEmail, password: newPassword)
            }
            return element
        }
    }
    
    
}
