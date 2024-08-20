//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 18.08.2024.
//

import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func didTapLogoutButton()
    func getAvatarURL(from stringURL: String?)
    func getProfileDetails(from profile: Profile?)
    func addProfileImageServiceObserver()
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
            self.getAvatarURL(from: self.profileImageService.avatarURL)
        }
    }
    
    func getProfileDetails(from profile: Profile?) {
        guard let profile = profile else { return }
        view?.updateProfileDetails(with: profile)
    }
    
    func getAvatarURL(from stringURL: String?) {
        guard
            let profileImageURL = stringURL,
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
