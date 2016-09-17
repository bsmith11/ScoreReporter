//
//  MessageDisplayable.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import Anchorage

protocol MessageDisplayable {
    func configureMessageView(topLayoutGuide: UILayoutSupport)
    func displayMessage(message: String, animated: Bool)
    func hideMessageAnimated(animated: Bool)
}

extension MessageDisplayable where Self: UIViewController {
    var messageLayoutGuide: UILayoutSupport {
        return messageView
    }
    
    func configureMessageView(topLayoutGuide: UILayoutSupport) {
        if !view.subviews.contains(messageView) {
            view.addSubview(messageView)
            
            messageView.topAnchor == topLayoutGuide.bottomAnchor
            messageView.leadingAnchor == view.leadingAnchor
            messageView.trailingAnchor == view.trailingAnchor
        }
    }
    
    func displayMessage(message: String, animated: Bool) {
        messageView.configureWithTitle(message)
        messageView.display(true, animated: animated)
    }
    
    func hideMessageAnimated(animated: Bool) {
        messageView.display(false, animated: animated)
    }
}

// MARK: - Private

private extension MessageDisplayable where Self: UIViewController {
    var messageView: MessageView {
        guard let object = objc_getAssociatedObject(self, &MessageView.associatedKey) as? MessageView else {
            let object = MessageView(frame: .zero)
            objc_setAssociatedObject(self, &MessageView.associatedKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return object
        }
        
        return object
    }
}
