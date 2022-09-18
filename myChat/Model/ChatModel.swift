//
//  ChatModel.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import Foundation

protocol ChatModelProtocol {
    func getMessages(completed: @escaping (MessageData) -> Void)
}

final class ChatModel {
    private var network: NetworkServiceProtocol?
    private var offset = -20
    
    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
    }
    
    private func generateNewURL(offset: Int) -> String {
        let baseURL = "https://numia.ru/api/getMessages?offset="
        let url = baseURL + String(offset + 20)
        
        return url
    }
}

extension ChatModel: ChatModelProtocol {
    func getMessages(completed: @escaping (MessageData) -> Void) {
        guard let url = URL(string: generateNewURL(offset: offset)) else { return }
        network?.getData(url: url, completionHandler: completed)
        offset += 20
    }
}
