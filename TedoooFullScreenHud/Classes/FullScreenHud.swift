//
//  FullScreenHud.swift
//  CreateShopFlowFeature
//
//  Created by Mor on 02/07/2022.
//

import Foundation
import JGProgressHUD

public class FullScreenHud: UIView {
    
    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let hud = JGProgressHUD()
    public var dismissAction: (() -> ())? = nil
    
    public var indicatorView: JGProgressHUDIndicatorView? {
        get {
            self.hud.indicatorView
        }
        set {
            self.hud.indicatorView = newValue
        }
    }
    public lazy var textLabel = self.hud.textLabel
    
    public func setBackground(shown: Bool) {
        self.backgroundColor = shown ? .init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5) : .clear
        self.isUserInteractionEnabled = shown
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
            self.alpha = 1.0
        }
    }
    
    public func dismiss(afterDelay: Double, onEnd: (() -> ())? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + afterDelay) { [weak self] in
            self?.dismiss()
            onEnd?()
        }
    }
    
    public var spin: Bool {
        get { isHidden }
        set {
            if newValue {
                self.show()
            } else {
                self.dismiss()
            }
        }
    }
    
    public func show() {
        guard let window = UIApplication.shared.keyWindow else { return }
        self.removeFromSuperview()
        window.addSubview(self)
        self.frame = window.bounds
        setBackground(shown: true)
        hud.tapOutsideBlock = { [weak self] _ in
            self?.dismissAction?()
        }
        hud.show(in: self)
    }
    
}
