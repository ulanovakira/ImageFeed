//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Кира on 21.08.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
                title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil
        )
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
