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
}


extension UIViewController {
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension String {
    /// mask example: `(###) ###-####`
    func formatToPhone() -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let mask    = "(###) ###-####"
        var result  = ""
        var index   = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "#" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
