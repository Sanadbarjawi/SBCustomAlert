//
//  CustomAlert.swift
//  UHive
//
//  Created by Ahmad Almasri on 10/11/18.
//  Copyright © 2018 Genie9. All rights reserved.
//

import Foundation
import UIKit

    public class CustomAlertButton: UIButton {
        public typealias CustomAlertButtonAction = () -> Void

        let title: String
        let textColor: UIColor
        let action: CustomAlertButtonAction?
        let dismissOnTap: Bool
        
        public init(title: String,textColor: UIColor,dismissOnTap: Bool = true, action: CustomAlertButtonAction? = nil) {
            self.title = title
            self.textColor = textColor
            self.action = action
            self.dismissOnTap = dismissOnTap
             super.init(frame: .zero)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    



public class SBCustomAlert: UIView, Modal {
   
    
    public var backgroundView = UIView()
    public var dialogView = UIView()
    private var messageLabel:UILabel!
    private let stackView = UIStackView()
    var buttons:[CustomAlertButton]?
    private var titleLabel: UILabel!
    private var seperatorLine: UIView!
    private var message:String?
    private var title:String?
    public var isCopy = false
    private var dialogViewWidth: CGFloat {
        
        return   frame.width-64
    }
    fileprivate func createtitleLabel(dialogWidth: CGFloat, title: String) {
        titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogWidth-16, height: 50))
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.textAlignment = .center
        dialogView.addSubview(titleLabel)
    }
    
    fileprivate func createSeperatorLineView(titleHeight: CGFloat, dialogWidth:CGFloat){
        seperatorLine = UIView()
        seperatorLine.frame.origin = CGPoint(x: 0, y: titleHeight + 8)
        seperatorLine.frame.size = CGSize(width: dialogWidth, height: 1)
        seperatorLine.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(seperatorLine)

    }
    
    fileprivate func createMessageLabel(seperatorLineHeight:CGFloat, dialogWidth: CGFloat, message:String, seperatorLineYPosition:CGFloat) {
        messageLabel = UILabel()
        messageLabel.frame.origin = CGPoint(x: 8, y: seperatorLineHeight + seperatorLineYPosition + 8)
        messageLabel.frame.size = CGSize(width: dialogWidth - 16 , height: dialogWidth - 16)
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.frame.size.height = textHeight()
        
        if isCopy {
        messageLabel.isUserInteractionEnabled = true
        messageLabel.addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(showCopyMenu(sender:))
        ))
        }
        dialogView.addSubview(messageLabel)

    }
    
    @objc private func showCopyMenu(sender: UILabel) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    override public func copy(_ sender: Any?) {
        
        UIPasteboard.general.string = messageLabel.text
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
    
    override public var canBecomeFirstResponder: Bool {
        
        return isCopy
    }
    public convenience init(title: String, message: String , buttons: [CustomAlertButton]? = nil) {
        self.init(frame: UIScreen.main.bounds)
        self.message = message
        self.title  = title
        self.buttons = buttons
    }
    
    public func addButtons(_ buttons: [CustomAlertButton]) {
        
        self.buttons = buttons
    }
    public func build() {
        
        initialize(title: title ?? "", message: message ?? "", buttons: buttons)

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createBackGroundWithAlpha() {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
    }
    
    fileprivate func configureDialog() {
        dialogView.clipsToBounds = true
        let dialogViewHeight = titleLabel.frame.height + 8 + seperatorLine.frame.height + 8 +  textHeight() + 8 + stackView.frame.height
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
    }
    
    func initialize(title:String, message:String, buttons:[CustomAlertButton]?){
        self.buttons = buttons
        createBackGroundWithAlpha()
        createtitleLabel(dialogWidth: dialogViewWidth, title: title)
        createSeperatorLineView(titleHeight: titleLabel.frame.height, dialogWidth: dialogViewWidth)
        createMessageLabel(seperatorLineHeight: seperatorLine.frame.height, dialogWidth: dialogViewWidth, message: message, seperatorLineYPosition: titleLabel.frame.height + 8)
        
        
        if !(buttons ?? []).isEmpty {
            addButtons(dialogViewWidth)
        }
        configureDialog()
        addSubview(dialogView)
    }
    
    
    private func addButtons(_ dialogViewWidth: CGFloat) {
        
        let isTwoButtonsOnly = (buttons?.count ??  0 ) == 2
        let buttonsTopSeperator = UIView()
        buttonsTopSeperator.frame.origin = CGPoint(x: 0, y: messageLabel.frame.height + messageLabel.frame.origin.y + 8)
        buttonsTopSeperator.frame.size = CGSize(width: dialogViewWidth, height: 1)
        buttonsTopSeperator.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(buttonsTopSeperator)
        
        
        stackView.frame.origin = CGPoint(x: 8, y: messageLabel.frame.height + messageLabel.frame.origin.y + 9)
        stackView.frame.size = CGSize(width: dialogViewWidth - 16 , height:   isTwoButtonsOnly ? 60 : (50 * (CGFloat(buttons?.count ??  0 )) ))
        
        for (_ , option) in buttons!.enumerated() {
            
            let button = option
            // let b = UIButton()
            button.setTitle(option.title, for: .normal)
            button.setTitleColor(option.textColor, for: .normal)
            
            button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            
            button.widthAnchor.constraint(equalToConstant: stackView.frame.width / 2 ).isActive = true
            
            let buttonHeight = button.heightAnchor.constraint(equalToConstant: 50)
            buttonHeight.isActive = true
            buttonHeight.priority = UILayoutPriority(rawValue: 999)
            stackView.addArrangedSubview(button)
            
            let buttonsSeperator = UIView()
            buttonsSeperator.widthAnchor.constraint(equalToConstant: isTwoButtonsOnly ? 1 : dialogViewWidth ).isActive = true
            buttonsSeperator.heightAnchor.constraint(equalToConstant: isTwoButtonsOnly ? 60 : 1).isActive = true
            
            buttonsSeperator.backgroundColor = UIColor.groupTableViewBackground
            stackView.addArrangedSubview(buttonsSeperator)
            
        }

        stackView.axis = isTwoButtonsOnly ? .horizontal : .vertical
        stackView.distribution = .fill
        
        dialogView.addSubview(stackView)
    }
    
    /// Calls the action closure of the button instance tapped
    @objc fileprivate func buttonTapped(_ button: CustomAlertButton) {
        
        if button.dismissOnTap {
            
            self.dismiss(animated: true) {
                
                button.action?()
            }
            
        } else {
            button.action?()
        }
        
    }
    
    private func textHeight() -> CGFloat {
        let font = messageLabel.font!
        let size = ((messageLabel.text ?? "") as NSString).size(withAttributes: [.font: font])
        let lines = Int(size.width / (self.frame.width ))
        return 60.0 + CGFloat(lines) * size.height
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true, nil)
    }
    
}
