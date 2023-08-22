//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Кира on 06.08.2023.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    let imageView: UIImageView = UIImageView()
    var authViewController = AuthViewController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage().token != nil {
            self.fetchProfile(token: OAuth2TokenStorage().token!)
        } else {
            switchToAuthViewController()
        }
    }
    
    func setProfileImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.image = UIImage(named: "LaunchScreen")
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 345)
        ])
    }}

extension SplashViewController: AuthViewControllerDelegate {
    func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
        
    }
}

extension SplashViewController {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
         }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchAuthToken(code: code) { [weak self] result  in
            guard let self = self else { return }
            switch result {
                case .success(let token):
                    self.fetchProfile(token: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    showAlert()
                    break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let body):
                    ProfileImageService.shared.fetchProfileImageURL(username: body.username) { _ in }
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                print("Can not get profile info")
                showAlert()
                break
            }
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func showAlert() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonText: "Ок",
            completion: { [weak self] _ in
                guard let self = self else { return }
            }
        )
        AlertPresenter().showAlert(alert)
    }
}

extension SplashViewController: AlertPresenterDelegate {
    func present(_ alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
}
