//
//  MessageViewController.swift
//  myChat
//
//  Created by Никита Макаревич on 16.09.2022.
//

import UIKit

final class MessageViewController: UIViewController {
    
    private let chatViewController = ChatViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        chatViewController.delegate = self
        view.backgroundColor = UIColor.white
    }

}

extension MessageViewController: ChatViewControllerDelegate {
    func didTapMessage(message: MessageModel) {
        print("123")
        print(message)
    }
}
