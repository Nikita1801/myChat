//
//  ChatTableViewCell.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {

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
    
    func setInfo(message: String) {
        messageBody.text = message
    }
}

private extension ChatTableViewCell {
    func configureView() {
        addSubview(bubbleBackgroundView)
        addSubview(messageBody)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            messageBody.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            messageBody.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            messageBody.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageBody.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageBody.topAnchor, constant: -14),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageBody.leadingAnchor, constant: -14),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageBody.trailingAnchor, constant: 14),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageBody.bottomAnchor, constant: 14)
            
        ])
    }
}
