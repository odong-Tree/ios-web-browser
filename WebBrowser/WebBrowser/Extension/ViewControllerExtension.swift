//
//  ViewControllerExtension.swift
//  WebBrowser
//
//  Created by Wonhee on 2020/12/31.
//

import Foundation
import UIKit

extension UIViewController {
    func showError(_ error: Error) {
        let alert: UIAlertController
        if let webError = error as? WebError {
            alert = UIAlertController(title: nil, message: webError.errorDescription, preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: nil, message: WebError.unknow.errorDescription, preferredStyle: .alert)
        }
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirmAction)
        self.present(alert, animated: false, completion: nil)
    }
}
