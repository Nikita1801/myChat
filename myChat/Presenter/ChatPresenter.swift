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
    private let incomeImageURL = "https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-PNG-Photos.png"
    
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
                    messageModelArray.append(MessageModel(message: message, photoURL: self.incomeImageURL, isIncoming: true))
                }
                chatViewController?.updateMessages(messageModelArray)
            }
        })
    }
}
