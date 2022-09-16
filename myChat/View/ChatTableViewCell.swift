//
//  ChatTableViewCell.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    var message: MessageModel! {
        didSet {
            bubbleBackgroundView.backgroundColor = message.isIncoming ? UIColor(named: "bubble") : UIColor(named: "outcomeBubble")
            messageBody.textColor = message.isIncoming ? UIColor(named: "textColor") : .white
            
            if message.isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }
            else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
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
    }
}

private extension ChatTableViewCell {
    /// configuring view
    func configureView() {
        addSubview(bubbleBackgroundView)
        addSubview(messageBody)
        
        setConstraints()
    }
    
    /// setting constraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            messageBody.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            messageBody.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageBody.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageBody.topAnchor, constant: -14),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageBody.leadingAnchor, constant: -14),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageBody.trailingAnchor, constant: 14),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageBody.bottomAnchor, constant: 14)
            
        ])
        
        leadingConstraint = messageBody.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageBody.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        trailingConstraint.isActive = false
    }
}
