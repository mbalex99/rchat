//
//  RChatInputView.swift
//  RChat
//
//  Created by Max Alexander on 1/10/17.
//  Copyright © 2017 Max Alexander. All rights reserved.
//

import UIKit

protocol RChatInputViewDelegate : class {
    func sendMessage(text: String)
    func attachmentButtonDidTapped()
}

class RChatInputView : UIView, UITextViewDelegate {

    weak var delegate : RChatInputViewDelegate?

    let textView : UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 40)
        textView.isScrollEnabled = false
        textView.layer.borderColor = RChatConstants.Colors.silver.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 36 / 2
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = RChatConstants.Fonts.regularFont
        return textView
    }()

    lazy var topBorder : UIView = {
        let view = UIView()
        view.backgroundColor = RChatConstants.Colors.silver
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var attachmentButton : UIButton = {
        let button = UIButton()
        button.tintColor = RChatConstants.Colors.primaryColor
        let image = RChatConstants.Images.attachIcon
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var sendButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 28 / 2
        button.layer.masksToBounds = true
        button.backgroundColor = RChatConstants.Colors.primaryColor
        let image = RChatConstants.Images.sendIcon
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(){
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = RChatConstants.Colors.clouds

        addSubview(textView)
        addSubview(attachmentButton)
        addSubview(topBorder)
        addSubview(sendButton)

        textView.delegate = self
        sendButton.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
        attachmentButton.addTarget(self, action: #selector(attachmentButtonDidTap), for: .touchUpInside)

        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[topBorder]-0-|", options: [], metrics: nil, views: ["topBorder": topBorder])
        )
        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[topBorder(1)]", options: [], metrics: nil, views: ["topBorder": topBorder])
        )

        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:|-8-[attachmentButton(33)]-8-[textView]-16-|", options: [], metrics: nil, views:
                ["attachmentButton": attachmentButton, "textView": textView])
        )
        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:[attachmentButton(33)]-8-|", options: [], metrics: nil, views: ["attachmentButton": attachmentButton])
        )
        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:|-8-[textView(>=37)]-8-|", options: [], metrics: nil, views: ["textView": textView])
        )
        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:
                "H:[sendButton(28)]-22-|", options: [], metrics: nil, views: ["sendButton": sendButton])
        )
        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat:
                "V:[sendButton(28)]-13-|", options: [], metrics: nil, views: ["sendButton": sendButton])
        )

    }

    func textViewDidChange(_ textView: UITextView) {
        evaluateSendButtonAlpha()
    }

    func evaluateSendButtonAlpha(){
        let text = textView.text ?? ""
        let alpha : CGFloat = text.characters.count == 0 ? 0 : 1
        UIView.animate(withDuration: 0.25) {
            self.sendButton.alpha = alpha
        }
    }

    func sendButtonDidTap(){
        delegate?.sendMessage(text: textView.text)
        textView.text = ""
        evaluateSendButtonAlpha()
    }

    func attachmentButtonDidTap(){
        delegate?.attachmentButtonDidTapped()
    }

    override func layoutSubviews() {
        self.updateConstraints() // Interface rotation or size class changes will reset constraints as defined in interface builder -> constraintsForVisibleTextView will be activated
        super.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
