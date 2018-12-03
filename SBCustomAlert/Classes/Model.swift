//
//  Modal.swift
//  UHive
//
//  Created by Ahmad Almasri on 10/11/18.
//  Copyright © 2018 Genie9. All rights reserved.
//

import Foundation
import UIKit

public protocol Modal where Self: UIView {
    func show(animated:Bool)
    func dismiss(animated: Bool, _ completion:(()->Void)?)
    var backgroundView:UIView { get }
    var dialogView:UIView { get set }
}

extension Modal {
   public func show(animated: Bool) {
        self.backgroundView.alpha = 0
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.dialogView.center = self.center
            }, completion: { (completed) in
                
            })
        } else {
            self.backgroundView.alpha = 0.66
            self.dialogView.center = self.center
        }
    }
    
    public func dismiss(animated: Bool, _ completion:(()->Void)?) {
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in

            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
                self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
            }, completion: { (completed) in
                self.removeFromSuperview()
                completion?()
            })
        } else {
            self.removeFromSuperview()
             completion?()
        }
        
    }
}
