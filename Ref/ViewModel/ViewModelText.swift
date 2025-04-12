//
//  ViewModelText.swift
//  Presentations
//
//  Created by Mateus Ottoni on 04/04/25.
//

import Foundation

class ViewModelText : ObservableObject {
    
    @Published var transcricoes : [Transcription] = []
    
    func fetch() {
        // Acesso à API
        guard let url = URL(string: "http://192.168.128.9:1880/leituraPresentationsText")
                        else { return } // Retornar vazio se a URL não for válida
        
        // Variável para buscar os dados da URL
        let task = URLSession.shared.dataTask(with: url) {
            [weak self] data, _, error in
            
            // Para evitar vazamento de memória
            guard let data = data, error == nil else {
                return
            }
            
            // Parsing
            do {
                let parsed = try JSONDecoder().decode([Transcription].self, from: data)
                
                DispatchQueue.main.async {
                    self?.transcricoes = parsed
                }
            } catch {
                // Print do erro em caso de falha
                print(error)
            }
            
        } // Fim task
        task.resume()
        
        
        
    } // Fim func fetch()
    
    func post_request(_ obj : Transcription ) {
        
        // Acesso à API
        guard let url = URL(string: "http://192.168.128.9:1880/postPresentationsText")
        else { return } // Retornar vazio se a URL não for válida

        // create post request
        var apiRequest = URLRequest(url: url)
        apiRequest.httpMethod = "POST"
        
        var headers = apiRequest.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        apiRequest.allHTTPHeaderFields = headers
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(obj)
            apiRequest.httpBody = jsonData
            print("jsonData: ", String(data: apiRequest.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("Error encoding to JSON: \(error.localizedDescription)")
        }

        let task = URLSession.shared.dataTask(with: apiRequest) { data, response, error in
            if let error = error {
                print("Error to send resource: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error to send resource: invalid response")
                return
            }
            if httpResponse.statusCode == 200 {
                print("Resource POST successfully")
            } else {
                print("Error POST resource: status code \(httpResponse.statusCode)")
            }
        }
        
        
        task.resume()
    } // Fim func post_request
    
    
} // Fim class ViewModelPresentation
