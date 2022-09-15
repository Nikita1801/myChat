//
//  ChatService.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getData(url: URL, completionHandler: @escaping (MessageModel) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func getData(url: URL, completionHandler: @escaping (MessageModel) -> Void) {
        
        getRequest(url: url) { data in
            guard let model = try? JSONDecoder().decode(MessageModel.self, from: data)
            else {
                print("Error while parsing")
                return
            }
            
            completionHandler(model)
        }
    }
}

private extension NetworkService {
    func getRequest(url: URL, completed: @escaping (Data) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
            }
            guard let data = data else {
                print("Error")
                return
            }
            completed(data)
        }
        task.resume()
    }
}
