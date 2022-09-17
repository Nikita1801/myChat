//
//  MessageViewController.swift
//  myChat
//
//  Created by Никита Макаревич on 16.09.2022.
//

import UIKit

protocol MessageViewControllerDelegate: UIViewController {
    func didTapMessage(message: MessageModel)
}

final class MessageViewController: UIViewController {
    
    weak var delegate: ChatViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сообщение"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 50
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let messageBodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "14:00"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete message", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRemoveMessage), for: .touchUpInside)
        
        return button
    }()
    
    private let bubbleBackgroundView: UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor(named: "bubble")
        bubbleView.layer.cornerRadius = 10
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        return bubbleView
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    @objc private func didTapRemoveMessage() {
        dismiss(animated: true)
        delegate?.removeMessage()
    }
}

private extension MessageViewController {
    func configureView() {
        view.backgroundColor = UIColor.systemGray5
        view.addSubview(backgroundImage)
        view.addSubview(bubbleBackgroundView)
        view.addSubview(titleLabel)
        view.addSubview(photoImageView)
        view.addSubview(messageBodyLabel)
        view.addSubview(timeLabel)
        view.addSubview(deleteButton)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageBodyLabel.topAnchor, constant: -14),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageBodyLabel.leadingAnchor, constant: -14),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageBodyLabel.trailingAnchor, constant: 14),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageBodyLabel.bottomAnchor, constant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            photoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            messageBodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            messageBodyLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 34),
            messageBodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34),
            
            timeLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -10),
            timeLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -7),

            deleteButton.topAnchor.constraint(equalTo: messageBodyLabel.bottomAnchor, constant: 40),
            deleteButton.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant:  -20)
            
        ])
    }
}

// MARK: - Loading image extension
private extension MessageViewController {
    func getImage(imageURL: String, imageView: UIImageView) {
        if let url = URL(string: imageURL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}

extension MessageViewController: MessageViewControllerDelegate {
    func didTapMessage(message: MessageModel) {
        messageBodyLabel.text = message.message
        messageBodyLabel.textColor = message.isIncoming ? UIColor(named: "textColor") : .white
        timeLabel.textColor = message.isIncoming ? UIColor(named: "textColor") : .white
        bubbleBackgroundView.backgroundColor = message.isIncoming ? UIColor(named: "bubble") : UIColor(named: "outcomeBubble")
        getImage(imageURL: message.photoURL, imageView: photoImageView)
    }
}
