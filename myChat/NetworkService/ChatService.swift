//
//  ChatService.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getData(url: URL, completionHandler: @escaping (MessageData?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func getData(url: URL, completionHandler: @escaping (MessageData?) -> Void) {
        
        getRequest(url: url) { [weak self] data in
            guard let model = try? JSONDecoder().decode(MessageData.self, from: data)
            else {
//                self?.getData(url: url, completionHandler: completionHandler)
                completionHandler(nil)
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
