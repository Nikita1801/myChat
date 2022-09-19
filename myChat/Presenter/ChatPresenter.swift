//
//  ChatPresenter.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import Foundation

protocol ChatPresenterProtocol {
    /// call Model to make API request
    func getMessages(isLastRequestSuccessful: Bool)
    
    func saveOutcomeMessages(messages: [MessageModel])
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
    func saveOutcomeMessages(messages: [MessageModel]) {
        let outcomeMessagesArray = messages.filter { $0.isIncoming == false }
        print("saving: \(outcomeMessagesArray)")
        print("SAVEEE________________")
    }
    
    
    func getMessages(isLastRequestSuccessful: Bool) {
        chatModel?.getMessages(isLastRequestSuccessful: isLastRequestSuccessful, completed: { [weak chatViewController] messages in
            DispatchQueue.main.async {
                var messageModelArray: [MessageModel] = []
                guard let messages = messages?.result else {
                    chatViewController?.updateMessages(nil)
                    return
                }
                for message in messages {
                    messageModelArray.append(MessageModel(message: message, photoURL: self.incomeImageURL, isIncoming: true))
                }
                chatViewController?.updateMessages(messageModelArray)
            }
        })
    }
}
