//
//  ChatVC.swift
//  BaseProject
//
//  Created by Michael Seven on 3/20/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import UIKit
import MessageKit

//import UIKit
import InputBarAccessoryView
import Firebase
//import MessageKit
import FirebaseFirestore
//import SDWebImage


class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {


    var currentUser: User = Auth.auth().currentUser!
    
    var user2Name: String?
    var user2ImgUrl: String?
    var user2UID: String?
    
    private var docReference: DocumentReference?
    
    var messages: [Message] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user2UID = "ENPiCjjJshgUVuThIGiKErYwzUu1"
        self.user2Name = "Đoàn Bảy"
        
//        self.user2UID = "AJm3WYMUQPbJ5LMP1AsrpjHNUpG2"
//        self.user2Name = "test ngân"
        
//        self.user2UID = "liNmrF9M5bM0ebjoGFJjqsRSerE2"
//        self.user2Name = "test 2 ngan"
        
        self.title = user2Name ?? "Chat"

        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .blue
        messageInputBar.sendButton.setTitleColor(.green, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
        
    }
    
    // MARK: - Custom messages handlers
    
    func createNewChat() {
        let users = [self.currentUser.uid, self.user2UID]
        print("7_ chat: currentUser.uid = \(self.currentUser.uid)")
         let data: [String: Any] = [
             "users":users
         ]
         
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        let db = firestore.collection("Collection_Name_CR7")

         db.addDocument(data: data) { (error) in
             if let error = error {
                 print("Unable to create chat! \(error)")
                 return
             } else {
                 self.loadChat()
             }
         }
    }
    
    func loadChat() {
        
        //Fetch all the chats which has current user in it
//        let db = Firestore.firestore().collection("Chats")
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        let db = firestore.collection("Collection_Name_CR7")
                .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        
        
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    self.createNewChat()
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        
                        if let chat = Chat(dictionary: doc.data()) {
                        
                            //check user2 is exits in list
    //                        if let user2UID = self.user2UID, let containUser2 = chat?.users.contains(user2UID) {} else {
    //                            print("7_ chat: user2UID is not exits in list")
    //                            self.createNewChat()
    //                            return
    //                        }
                            
                            //Get the chat which has user2 id
                            if (chat.users.contains(self.user2UID!)) {
                                self.docReference = doc.reference
                                //fetch it's thread collection
                                 doc.reference.collection("thread")
//                                    .order(by: "created", descending: false)
                                    .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                        guard let snapshot = threadQuery else { return }
                                        
                                        
                                        for diff in snapshot.documentChanges {
                                            if diff.type == .added  {
                                                print("New data: \(diff.document.data())")
                                            }
                                            print("diff: \(diff.document)")
                                        }
                                        
                                        let source = snapshot.metadata.isFromCache ? "local" : "server"
                                        print("Metadata: Data fetch from \(source)")
                                        
                                        for message in snapshot.documents {
                                            print("Metadata: Data \(message)")
                                        }
                                        
                                        if let error = error {
                                            print("Error: \(error)")
                                            return
                                        } else {
                                            self.messages.removeAll()
                                                for message in threadQuery!.documents {

                                                    let msg = Message(dictionary: message.data())
                                                    self.messages.append(msg!)
                                                    print("7_ chat: Id \(msg?.id)")
                                                    print("7_ chat: senderID \(msg?.senderID)")
                                                    print("7_ chat: senderName \(msg?.senderName)")
                                                    print("Data: \(msg?.content ?? "No message found")")
                                                }
                                            self.messagesCollectionView.reloadData()
                                            self.messagesCollectionView.scrollToBottom(animated: true)
                                        }
                                })
                                return
                            }
                        } //end of if
                    } //end of for
                    self.createNewChat()
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }
    
    
    private func insertNewMessage(_ message: Message) {
        
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    private func save(_ message: Message) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
            
        })
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
            func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

                let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: currentUser.displayName!)
                
                  //messages.append(message)
                  insertNewMessage(message)
                  save(message)
    
                  inputBar.inputTextView.text = ""
                  messagesCollectionView.reloadData()
                  messagesCollectionView.scrollToBottom(animated: true)
            }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return messages.count
        }
    }
    
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == currentUser.uid {
//            SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//                avatarView.image = image
//            }
        } else {
//            SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl!), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = UIImage(named: "mec")
//            }
        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)

    }
    
}


struct Chat {
    
    var users: [String]
    
    var dictionary: [String: Any] {
        return [
            "users": users
        ]
    }
}

extension Chat {
    
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
    
}


struct Message {
    
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String
    
    var dictionary: [String: Any] {
        
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName":senderName]
        
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? Timestamp,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String
            else {return nil}
        
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
        
    }
}

extension Message: MessageType {
    
    var sender: SenderType {
        return Sender(id: senderID, displayName: senderName)
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return created.dateValue()
    }
    
    var kind: MessageKind {
        return .text(content)
    }
}
