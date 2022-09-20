//
//  ChatViewController.swift
//  myChat
//
//  Created by Никита Макаревич on 14.09.2022.
//

import UIKit

protocol ChatViewControllerProtocol: AnyObject {
    /// Getting message array
    func updateMessages(_ messages: [MessageModel]?)
    
}

protocol ChatViewControllerDelegate: AnyObject {
    /// remove message from message list
    func removeMessage(message: MessageModel)
}


final class ChatViewController: UIViewController {
    
    private var chatPresenter: ChatPresenterProtocol?
    private lazy var messageViewContoller: MessageViewControllerDelegate = {
        let message = MessageViewController()
        message.delegate = self
        return message
    }()
    private var messageModelArray: [MessageModel] = []
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
    private let outcomeImageURL = "https://e7.pngegg.com/pngimages/674/524/png-clipart-professional-computer-icons-avatar-job-avatar-heroes-computer.png"
    private var messageIndex = 0
    private var fetchingMoreData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatPresenter = ChatPresenter(chatViewController: self)
        let outcomeMessages = chatPresenter?.fetchOutcomeMessages()
        guard let outcomeMessages = outcomeMessages else { return }
        messageModelArray = outcomeMessages
        
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
        let outcomeMessage = MessageModel(message: textField.text ?? "",
                                          photoURL: outcomeImageURL,
                                          isIncoming: false)
        messageModelArray.append(outcomeMessage)
        chatTableView.reloadData()
        scrollToBottom(animated: true, indexPath: messageModelArray.count-1)
        textField.text = ""
        
        // send data to presenter to save into CoreData
        chatPresenter?.saveOutcomeMessages(message: outcomeMessage)
        
        return true
    }
}

// MARK: - Getting messages and configuring view with constraints
private extension ChatViewController {
    /// getting messages from server by API call
    func getMessages() {
        chatPresenter?.getMessages(isLastRequestSuccessful: true)
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
    
    /// Creating spinner for loading animation
    func createSpinner() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        return view
    }
    
    /// Show alert when getting error from the server
    func showAlert() {
        // create the alert
        let alert = UIAlertController(title: "Ошибка при загрузке",
                                      message: "Желаете повторить загрузку?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Повтроить загрузку",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
            self.chatPresenter?.getMessages(isLastRequestSuccessful: false) } ))
        alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.cancel, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - ChatViewControllerDelegate extension (Deleating message)
extension ChatViewController: ChatViewControllerDelegate {
    /// remove message by messageIndex and reloading data
    func removeMessage(message: MessageModel) {
        messageModelArray.remove(at: messageIndex)
        chatPresenter?.deleteOutcomeMessage(message: message)
        chatTableView.reloadData()
    }
}

// MARK: - ChatViewControllerProtocol extension
extension ChatViewController: ChatViewControllerProtocol {
    func updateMessages(_ messages: [MessageModel]?) {
        guard let messages = messages else {
            showAlert()
            return
        }
        
        messages.forEach { message in
            messageModelArray.insert(message, at: 0)
        }
        
        chatTableView.tableHeaderView = nil
        if fetchingMoreData,
           messages.count != 0,
           messageModelArray.count > 28 {
            chatTableView.reloadData()
            
            UIView.transition(with: chatTableView,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: { self.scrollToBottom(animated: false, indexPath: 28) })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.fetchingMoreData = false
            }
        }
        else if !fetchingMoreData, messages.count != 0 {
            chatTableView.reloadData()
            UIView.transition(with: chatTableView,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { self.scrollToBottom(animated: false, indexPath: self.messageModelArray.count-1) })
        }
    }
}

extension ChatViewController: UIScrollViewDelegate {
    /// Detect end of message list and request more data
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        guard position < -20, !fetchingMoreData else { return }

        chatTableView.tableHeaderView = createSpinner()
        fetchingMoreData = true
        chatPresenter?.getMessages(isLastRequestSuccessful: true)
        
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
        messageIndex = indexPath.row
        let chatMessage = messageModelArray[indexPath.row]
        messageViewContoller.didTapMessage(message: chatMessage)
    }
    
    /// Scroll to the very bottom, to see newest messanges
    /// - Parameter animated: animate this scroll
    func scrollToBottom(animated: Bool, indexPath: Int) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: indexPath, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
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

