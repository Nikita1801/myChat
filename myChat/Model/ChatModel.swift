//
//  ChatModel.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import Foundation

protocol ChatModelProtocol {
    func getMessages(completed: @escaping (MessageModel) -> Void)
}

final class ChatModel {
    private var network: NetworkServiceProtocol?
    
    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
    }
}

extension ChatModel: ChatModelProtocol {
    func getMessages(completed: @escaping (MessageModel) -> Void) {
        guard let url = URL(string: "https://numia.ru/api/getMessages?offset=0") else { return }
        network?.getData(url: url, completionHandler: completed)
    }
}
