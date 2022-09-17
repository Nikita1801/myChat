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
    
    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
    }
}

extension ChatModel: ChatModelProtocol {
    func getMessages(completed: @escaping (MessageData) -> Void) {
        guard let url = URL(string: "https://numia.ru/api/getMessages?offset=20") else { return }
        network?.getData(url: url, completionHandler: completed)
    }
}
