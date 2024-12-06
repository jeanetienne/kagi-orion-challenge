//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

class KeyboardObserver {

    private let notificationCenter: NotificationCenter = NotificationCenter.default

    private var showObserver: NSObjectProtocol?

    private var hideObserver: NSObjectProtocol?

    /// Block to be executed when the keyboard will show. This block is called within a `UIView.animate` block.
    var willShow: ((CGSize) -> Void)?

    /// Block to be executed when the keyboard will hide. This block is called within a `UIView.animate` block.
    var willHide: ((CGSize) -> Void)?

    deinit {
        stop()
    }

    func start() {
        if showObserver == nil {
            observeKeyboardWillShowNotification()
        }
        if hideObserver == nil {
            observeKeyboardWillHideNotification()
        }
    }

    func stop() {
        if let observer = showObserver {
            notificationCenter.removeObserver(observer)
            showObserver = nil
        }
        if let observer = hideObserver {
            notificationCenter.removeObserver(observer)
            hideObserver = nil
        }
    }

    // MARK: - Private helpers
    private func observeKeyboardWillShowNotification() {
        showObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { [unowned self] notification in
                self.handleKeyboardAnimation(withNotification: notification, animation: { keyboardSize in
                    self.willShow?(keyboardSize)
                })
            }
    }

    private func observeKeyboardWillHideNotification() {
        hideObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { [unowned self] notification in
                self.handleKeyboardAnimation(withNotification: notification, animation: { keyboardSize in
                    self.willHide?(keyboardSize)
                })
            }
    }

    private func handleKeyboardAnimation(withNotification notification: Notification, animation: @escaping (CGSize) -> Void) {
        guard
            let info = notification.userInfo,
            let keyboardSizeDictionary = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let animationDurationNumber = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let animationOptionsNumber = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return
        }

        let keyboardSize = keyboardSizeDictionary.cgRectValue.size
        let animationDuration = animationDurationNumber.doubleValue as TimeInterval
        let animationOptions = UIView.AnimationOptions(rawValue: animationOptionsNumber.uintValue)

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: animationOptions,
                       animations: { animation(keyboardSize) },
                       completion: nil)
    }

}
