//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Кира on 20.06.2023.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    private var label: UILabel?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let imageView: UIImageView = UIImageView(image: UIImage(named: "profileImage"))
    var nameLabel: UILabel = UILabel()
    var nickNameLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    let exitButton: UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileImage()
        setName()
        setNickNameLabel()
        setDescription()
        setButton()
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
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65)
        ])
    }
    
    @objc private func didTapButton() {
          for view in view.subviews {
              if view is UILabel {
                  view.removeFromSuperview()
              }
          }
      }
}
