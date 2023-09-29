//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Кира on 20.06.2023.
//

import Foundation
import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol  {
    var presenter: ProfilePresenterProtocol?
    
    private var label: UILabel?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let imageView: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var nickNameLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    let exitButton: UIButton = UIButton(type: .custom)
    
    let authTokenStorage = OAuth2TokenStorage()
    let profileService = ProfileService.shared
    let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        setProfileImage()
        setName()
        setNickNameLabel()
        setDescription()
        setButton()
        updateProfileInfo(profile: profileService.profile)
    }
    
    func setProfileImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.topAnchor , constant: 76),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setName() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = UIColor(named: "YP White")
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    func setNickNameLabel() {
        nickNameLabel.text = "@ekaterina_nov"
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        nickNameLabel.textColor = .lightGray
        view.addSubview(nickNameLabel)
        
        NSLayoutConstraint.activate([
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nickNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    func setDescription() {
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "YP White")
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    func setButton() {
        exitButton.setImage(UIImage(named: "logOutButton"), for: .normal)
        exitButton.tintColor = .red
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        exitButton.accessibilityIdentifier = "logoutButton"
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65)
        ])
    }

    
    func updateProfileInfo(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        nickNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
        
        let profilePresenter = ProfilePresenter()
        print("profilePresenter \(profilePresenter)")
        self.presenter = profilePresenter
        profilePresenter.view = self
        profilePresenter.observeNotifications()
//        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.DidChangeNotification, object: nil, queue: .main) { [weak self] _ in
//            guard let self = self else {return}
//            self.updateAvatar()
//        }
//        updateAvatar()
    }
    
    func updateAvatar() {
        guard let avatarURL = profileImageService.avatarURL,
              let url = URL(string: avatarURL)
        else { return }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        let placeholder = UIImage(named: "profileImagePlaceholder")
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.processor(processor)])
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Да",
            style: .cancel,
        handler: { [weak self] _ in
            guard let self = self else { return }
            OAuth2TokenStorage.clean()
            OAuth2TokenStorage.removeToken()
            
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
        }))
        alert.addAction(UIAlertAction(title: "Не надо", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapButton() {
          showAlert()
      }
}
