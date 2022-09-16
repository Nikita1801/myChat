//
//  ChatPresenter.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import Foundation

protocol ChatPresenterProtocol {
    func getMessages()
}

final class ChatPresenter {
    private weak var chatViewController: ChatViewControllerProtocol?
    private var chatModel: ChatModelProtocol?
    
    init(chatViewController: ChatViewControllerProtocol?,
         chatModel: ChatModelProtocol = ChatModel()) {
        self.chatViewController = chatViewController
        self.chatModel = chatModel
    }
}

extension ChatPresenter: ChatPresenterProtocol {
    func getMessages() {
        chatModel?.getMessages(completed: { [weak chatViewController] messages in
            DispatchQueue.main.async {
                var messageModelArray: [MessageModel] = []
                for message in messages.result {
                    messageModelArray.append(MessageModel(message: message, isIncoming: true))
                }
                chatViewController?.updateMessages(messageModelArray)
            }
        })
    }
}
