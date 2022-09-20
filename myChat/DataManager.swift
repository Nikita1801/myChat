//
//  ChatData.swift
//  myChat
//
//  Created by Никита Макаревич on 19.09.2022.
//

import Foundation
import CoreData

final class DataManager {
    
    static let shared = DataManager()
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ChatModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// Setting message to Core Data Message entity
    func settingMessage(messageBody: String, isIncomming: Bool, photoURL: String) {
        let message = Message(context: persistentContainer.viewContext)
        message.message = messageBody
        message.isIncoming = isIncomming
        message.photoURL = photoURL
    }
    
    /// Fetching messages from CoreData storage and getting them
    func fetchMessages() -> [Message] {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        
        var fetchedMessages: [Message] = []
        
        do{
            fetchedMessages = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error while fetching data")
        }
        
        return fetchedMessages
    }
    
    /// Deleting object from CoreData
    func delete(message: MessageModel) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        
        if let result = try? context.fetch(request) {
            for object in result {
                if object.message == message.message {
                    context.delete(object)
                }
            }
        }
        do {
            try context.save()
        } catch {
            print("Error while deleting message")
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
