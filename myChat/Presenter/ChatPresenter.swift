//
//  ChatPresenter.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import Foundation

protocol ChatPresenterProtocol {
    /// Call Model to make API request
    func getMessages(isLastRequestSuccessful: Bool)
    /// Save messages to CoreData when user write new message
    func saveOutcomeMessages(message: MessageModel)
    /// Fetching for outcome messages from CoreData
    func fetchOutcomeMessages() -> [MessageModel]
    /// Deleting outcome message when deleted on the ChatViewController()
    func deleteOutcomeMessage(message: MessageModel)
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
    
    func fetchOutcomeMessages() -> [MessageModel] {
        var messageModelArray: [MessageModel] = []
        let messages = DataManager.shared.fetchMessages()
        for message in messages {
            messageModelArray.append(MessageModel(message: message.message ?? "", photoURL: message.photoURL ?? "", isIncoming: message.isIncoming))
        }

        return messageModelArray
    }
    
    func saveOutcomeMessages(message: MessageModel) {
        DataManager.shared.settingMessage(messageBody: message.message, isIncomming: message.isIncoming, photoURL: message.photoURL)
        DataManager.shared.saveContext()
    }
    
    func deleteOutcomeMessage(message: MessageModel) {
        DataManager.shared.delete(message: message)
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
