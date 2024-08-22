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
        // Images
        let imagesListNavigationController = UINavigationController()
        let assemblyBuilder = AssemblyModuleBuilder()
        
        let imageListRouter = ImagesListRouter(navigationController: imagesListNavigationController, assemblyBuilder: assemblyBuilder)
        imageListRouter.initialViewController()
        let imagesListViewController = imagesListNavigationController
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "rectangle.stack.fill"),
            selectedImage: nil
        )
        
        
        // Profile
        let profileRouter = ProfileRouter(assemblyBuilder: assemblyBuilder)
        profileRouter.initialViewController()
        
        let profileViewController = profileRouter.navigationController
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "person.crop.circle.fill"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview("TabController") {
    TabBarController()
}
