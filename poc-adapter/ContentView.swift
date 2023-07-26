//
//  ContentView.swift
//  poc-adapter
//
//  Created by carlos amorim on 25/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var id: String = ""
    @State var email: String = ""
    @State var senha: String = ""
    @State var db: any DatabaseAdapter = FileManegerAdapter.instance
    var body: some View {
        TextField("id", text: $id).padding(.horizontal, 40)
        TextField("email", text: $email).padding(.horizontal, 40)
        TextField("Senha", text: $senha).padding(.horizontal, 40)
        Button("Cadastrar") {
            var registred = db.createElement(email: email, password: senha)
            if (registred != nil){
                print("""
                Elemento registrado com sucesso
                    id: \(registred!.id)
                    email: \(registred!.email)
                    senha: \(registred!.password)
                -----------------------------------
                """)
            }
        }
        Button("Atualizar") {
            db.fetch()
        }
            Button("Editar elemento pelo ID") {
                guard let id = Int(id) else {return}
                db.updateElement(id: id, newEmail: email, newPassword: senha)
            }
            
            Button("Deletar elemento pelo ID") {
                guard let id = Int(id) else {return}
                db.deleteElement(id: id)
            }
            Button("Mostrar Itens cadastrados") {
                db.list.forEach { item in
                        print("""
                            id: \(item.id)
                            email: \(item.email)
                            senha: \(item.password)
                        
                        """)
                    }
                print("""
    ------------------------------------------------------------------------------
    """)
            
            }
            
        }
    }
