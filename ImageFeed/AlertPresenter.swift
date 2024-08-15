//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 7/31/24.
//

import UIKit

struct AlertPresenter {
    
    static func showAlert(on vc: UIViewController, model: AlertModel) {
        showBasicAlert(on: vc,
                       title: model.title,
                       message: model.message,
                       buttons: model.buttons,
                       identifier: model.identifier,
                       completion: model.completion)
    }
    
    private static func showBasicAlert(on vc: UIViewController,
                                       title: String,
                                       message: String,
                                       buttons: [String],
                                       identifier: String,
                                       completion: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .systemBackground
        
        alert.view.accessibilityIdentifier = identifier
        
        for button in buttons {
            if button == "Не надо" || button == "Нет" {
                let action = UIAlertAction(title: button, style: .cancel, handler: nil)
                action.accessibilityIdentifier = button
                alert.addAction(action)
            } else {
                let action = UIAlertAction(title: button, style: .default) { _ in
                    completion()
                }
                action.accessibilityIdentifier = button
                alert.addAction(action)
            }
        }
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}

