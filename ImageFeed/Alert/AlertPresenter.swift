//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Кира on 21.08.2023.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func show(_ alert: AlertModel)
}

protocol AlertPresenterDelegate: AnyObject {
    func present(_ alert: UIAlertController, animated flag: Bool)
}

class AlertPresenter {
    private weak var delegate: AlertPresenterDelegate?
    
    func showAlert(_ alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alert.title, style: .default, handler: alertModel.completion) 
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
}
