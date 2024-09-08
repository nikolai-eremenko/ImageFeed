//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 01.08.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarAppearance()
        setupTabs()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .ypBlack
        setTabBarItemColors(appearance.stackedLayoutAppearance)
        tabBar.standardAppearance = appearance
    }
    
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = .ypGray
        itemAppearance.selected.iconColor = .ypWhite
    }
    
    private func setupTabs() {
        // MARK: - ImagesList Tab
        let imagesListViewController = ImagesListViewController()
        let imagesListService = ImagesListService.shared
        let dateFormatter = DateConvertor.shared
        let imagesHelper = ImagesListHelper(imagesListService: imagesListService,
                                            dateFormatter: dateFormatter,
                                            tokenStorage: OAuth2TokenStorage.shared)
        let imagesListViewPresenter = ImagesListViewPresenter(view: imagesListViewController,
                                                              imagesHelper: imagesHelper)
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(systemName: "rectangle.stack.fill"),
                                                           selectedImage: nil)
        
        // MARK: - Profile Tab
        let profileViewController = ProfileViewController()
        let tokenStorage = OAuth2TokenStorage.shared
        let profileService = ProfileService.shared
        let profileImageService = ProfileImageService.shared
        let profileHelper = ProfileHelper(tokenStorage: tokenStorage,
                                          profileService: profileService,
                                          profileImageService: profileImageService)
        let profileViewPresenter = ProfileViewPresenter(view: profileViewController,
                                                        profileHelper: profileHelper)
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(systemName: "person.crop.circle.fill"),
                                                        selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview("TabController") {
    TabBarController()
}
