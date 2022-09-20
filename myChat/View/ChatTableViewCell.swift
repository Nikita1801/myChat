//
//  ChatTableViewCell.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {
    
    private var incomeMessageConstraint: [NSLayoutConstraint] = []
    private var outcomeMessageConstraint: [NSLayoutConstraint] = []
    
    var message: MessageModel? {
        didSet {
            guard let incommingMessage = message?.isIncoming else { return }
            bubbleBackgroundView.backgroundColor = incommingMessage ? UIColor(named: "bubble") : UIColor(named: "outcomeBubble")
            messageBody.textColor = incommingMessage ? UIColor(named: "textColor") : .white
            
            if incommingMessage {
                NSLayoutConstraint.activate(incomeMessageConstraint)
                NSLayoutConstraint.deactivate(outcomeMessageConstraint)
            }
            else {
                NSLayoutConstraint.activate(outcomeMessageConstraint)
                NSLayoutConstraint.deactivate(incomeMessageConstraint)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let messageBody: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: "textColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bubbleBackgroundView: UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor(named: "bubble")
        bubbleView.layer.cornerRadius = 10
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        return bubbleView
    }()
    
    /// setting info to cell's UI elements
    func setInfo(message: MessageModel) {
        messageBody.text = message.message
        getImage(imageURL: message.photoURL, imageView: photoImageView)
    }
}

// MARK: - Loading image extension
private extension ChatTableViewCell {
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

// MARK: - Configuring UI extension
private extension ChatTableViewCell {
    /// configuring view
    func configureView() {
        addSubview(bubbleBackgroundView)
        addSubview(messageBody)
        addSubview(photoImageView)
        
        setConstraints()
    }
    
    /// setting constraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            photoImageView.heightAnchor.constraint(equalToConstant: 30),
            photoImageView.widthAnchor.constraint(equalToConstant: 30),
            photoImageView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor),
            
            messageBody.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            messageBody.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageBody.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageBody.topAnchor, constant: -14),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageBody.leadingAnchor, constant: -14),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageBody.trailingAnchor, constant: 14),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageBody.bottomAnchor, constant: 14)
            
        ])
        
        incomeMessageConstraint = [
            messageBody.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            photoImageView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: -5)
        ]
        
        outcomeMessageConstraint = [
            messageBody.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            photoImageView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: 5)
        ]
    }
}
