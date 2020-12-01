//
//  Extensions.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit


extension UIView {
    func addSubviews(views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    func createDismissKBGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
    }
    
    func pin(view: UIView, in parent: UIView) {
        parent.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo:       parent.topAnchor),
            view.leadingAnchor.constraint(equalTo:   parent.leadingAnchor),
            view.trailingAnchor.constraint(equalTo:  parent.trailingAnchor),
            view.heightAnchor.constraint(equalTo:    parent.heightAnchor)
        ])
    }
}


extension UIViewController {
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func presentCLAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = CLAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}

extension String {
    func isWhitespace() -> Bool {
        return self.trimmingCharacters(in: .whitespaces) == ""
    }
    
    /// mask example: `(###) ###-####`
    func formatToPhone() -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let mask    = "(###) ###-####"
        var result  = ""
        var index   = numbers.startIndex // numbers iterator

        for ch in mask where index < numbers.endIndex {
            if ch == "#" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else { result.append(ch) }
        }
        return result
    }
}
