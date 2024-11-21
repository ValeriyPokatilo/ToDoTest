//
//  NetworkService.swift
//  ToDo
//
//  Created by Valeriy P on 20.11.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func getTasks(completion: @escaping (Result<[DummyTask]?, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func getTasks(completion: @escaping (Result<[DummyTask]?, Error>) -> Void) {
        guard let url = URL(string: .apiString) else { return }
  
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: .apiString) else {
                return
            }
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }

                do {
                    let obj = try JSONDecoder().decode(DummyData.self, from: data)
                    completion(.success(obj.todos))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
