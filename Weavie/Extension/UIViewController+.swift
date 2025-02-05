//
//  UIViewController+.swift
//  Weavie
//
//  Created by 정인선 on 1/29/25.
//

import UIKit

extension UIViewController {
    func showAlert(withCancel: Bool,
                   title: String? = nil,
                   message: String? = nil,
                   style: UIAlertController.Style = .alert,
                   actionTitle: String? = nil,
                   actionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if withCancel {
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancelAction)
        }
        if let actionTitle {
            let action = UIAlertAction(title: actionTitle, style: .default) { _ in
                actionHandler?()
            }
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}
