//
//  ApiAdapter.swift
//  poc-adapter
//
//  Created by carlos amorim on 25/07/23.
//

import Foundation

struct ReturnedObject: Decodable {
    var id: Int
    var email:String
    var password:String
    var rule:String
    var created_at:String
    var updated_at: String
}

class ApiAdapter: DatabaseAdapter {
    var list: [ElementAdapter] = []
    private var url: URL
    var request: URLRequest
    static var instance: any DatabaseAdapter = ApiAdapter()
    
    private init() {
        url = URL(string: "https://elite-fortal-docker.onrender.com/api/users")!
        request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        fetch()
    }
    
    func fetch() {
        request.httpMethod = "GET"
        request.httpBody = nil
        print("Entrou aqui")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }

            if let data = data {
                do{
                    print("Esteve aqui")
                    self.list = []
                    let responseStringg = String(data: data, encoding: .utf8)!
                            print(responseStringg)
                    let responseString = try JSONDecoder().decode([ReturnedObject].self, from: data)
                    responseString.forEach { user in
                        

                        print("Passou aqui aqui")
                        self.list.append(ElementAdapter(id: user.id, email: user.email, password: user.password))
                    }
                }catch{
                    print("deu erro na conversao")
                }
                
            }
        }

        task.resume()
    }
    
    func createElement(email: String, password: String) -> ElementAdapter? {
        request.httpMethod = "POST"
        let jsonData = try! JSONEncoder().encode(["email": email, "password": password])
        request.httpBody = jsonData
        var returnElement: ElementAdapter = ElementAdapter(id: Int.random(in: 1...100000), email: email, password: password)
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Verifica se a requisição teve sucesso
            if let error = error {
                print(error)
                return
            }

            // Verifica o código de status da resposta
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode != 200 {
                print("Erro: código de status não é 200")
                return
            }

            // Decodifica os dados da resposta
            if let data = data {
                do {
                    let responseObject = try JSONDecoder().decode(ReturnedObject.self, from: data)
//                    guard let id = responseObject.id, let email = responseObject.email, let password = responseObject.password else { return }
                    returnElement = ElementAdapter(id: responseObject.id, email: responseObject.email, password: responseObject.password)
                    print("Carregou")
                } catch {
                    print(error)
                }
            }
        }

        // Executa a tarefa
        task.resume()
        return returnElement
    }
    
    func deleteElement(id: Int) -> Bool {
        return false
    }
    
    func updateElement(id: Int, newEmail: String, newPassword: String) {
        
    }
    
    
}
