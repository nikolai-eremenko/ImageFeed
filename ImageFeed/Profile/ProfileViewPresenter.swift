//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 18.08.2024.
//

import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func addProfileImageServiceObserver()
    func setProfileDetails()
    func setAvatarURL()
    func didTapLogoutButton()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {

    weak var view: ProfileViewControllerProtocol?
    
    /// Нужен для управления жизненным циклом
    /// Когда объект ProfileViewPresenter будет деаллоцирован, и вместе с этим будет уничтожена ссылка profileImageServiceObserver
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func addProfileImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.setAvatarURL()
        }
    }
    
    func setProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(name: profile.name, login: profile.loginName, bio: profile.bio ?? "")
    }
    
    func setAvatarURL() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        
        view?.updateAvatar(with: url)
    }
    
    func didTapLogoutButton() {
        view?.showLogoutAlert(model: logoutAlertModel())
    }
    
    private func logoutAlertModel() -> AlertModel {
        let model = AlertModel(
            title: "Пока, пока!",
            message: "Уверенные что хотите выйти?",
            buttons: [.yesButton, .noButton],
            identifier: "Logout",
            completion: {
                self.profileService.logout(self.view as! ProfileViewController)
            }
        )
        return model
    }
}
