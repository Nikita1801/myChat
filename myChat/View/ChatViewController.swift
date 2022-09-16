//
//  ChatViewController.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import UIKit

protocol ChatViewControllerProtocol: AnyObject {
    /// Getting message array
    func updateMessages(_ messages: [MessageModel])
}

protocol ChatViewControllerDelegate: AnyObject {
    func didTapMessage(message: MessageModel)
}

final class ChatViewController: UIViewController {
    
    weak var delegate: ChatViewControllerDelegate?
    private var chatPresenter: ChatPresenterProtocol?
    private let messageViewContoller = MessageViewController()
    private var messageArray: [String] = []
    private var messageModelArray: [MessageModel] = []
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatPresenter = ChatPresenter(chatViewController: self)
        getMessages()
        
        configureView()
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Тестовое задание"
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Сообщение"
        textField.backgroundColor = UIColor(named: "bubble")
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
}

// MARK: - UITextField Delegate extension
extension ChatViewController: UITextFieldDelegate {
    
    /// Append send message to main array and clean textFiled line
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageArray.append(textField.text ?? "")
        messageModelArray.append(MessageModel(message: textField.text ?? "", isIncoming: false))
        chatTableView.reloadData()
        scrollToBottom(animated: true)
        textField.text = ""
        return true
    }
}

// MARK: - Getting messages and configuring view with constraints
private extension ChatViewController {
    /// getting messages from server by API call
    func getMessages() {
        chatPresenter?.getMessages()
    }
    
    /// Configuring view
    func configureView() {
        view.backgroundColor = .systemGray5
        chatTableView.delegate = self
        chatTableView.dataSource = self
        textField.delegate = self
        view.addSubview(backgroundImage)
        view.addSubview(headerLabel)
        view.addSubview(chatTableView)
        view.addSubview(textField)
        configureKeyboard()
        
        setConstraints()
    }
    
    /// Setting constraints to the view
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 40),
            
            chatTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -10),
            
            textField.topAnchor.constraint(equalTo: chatTableView.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
}

// MARK: - Keyboard Configuration
private extension ChatViewController {
    
    /// Configuring view by keyboard position
    func configureKeyboard() {
        
        let willShow = UIResponder.keyboardWillShowNotification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: willShow,
            object: nil
        )

        let willHide = UIResponder.keyboardWillHideNotification
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(keyboardWillHide(sender:)),
            name: willHide,
            object: nil);
    }
    
    /// Get iphone's keyboard height and  move view to keyboardHeight pixels up
    @objc func keyboardWillShow(_ notification: Notification) {
        view.addGestureRecognizer(tapGesture)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = -keyboardHeight + 20
        }
    }
    
    /// Move view to original position
    @objc func keyboardWillHide(sender: NSNotification) {
        view.removeGestureRecognizer(tapGesture)
         self.view.frame.origin.y = 0
    }
    
    /// Hide keyboard when user taps somewhere outside of the textfield
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}

extension ChatViewController: ChatViewControllerProtocol {
    func updateMessages(_ messages: [MessageModel]) {
        messageModelArray = messages.reversed()
        chatTableView.reloadData()
        scrollToBottom(animated: false)
    }
}

// MARK: - TableView extension
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageModelArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        let chatMessage = messageModelArray[indexPath.row]
        cell.setInfo(message: chatMessage)
        cell.message = chatMessage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.present(messageViewContoller, animated: true)
        let chatMessage = messageModelArray[indexPath.row]
        delegate?.didTapMessage(message: chatMessage)
    }
    
    /// Scroll to the very bottom, to see newest messanges
    /// - Parameter animated: animate this scroll
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messageModelArray.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
}



