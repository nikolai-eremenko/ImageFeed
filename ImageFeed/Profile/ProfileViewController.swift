//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 13.06.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    private let profileService = ProfileService.shared
    private let storage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: - UI Components
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img.photo")
        imageView.tintColor = .ypGray
        imageView.backgroundColor = .ypWhite
        imageView.layer.cornerRadius = 35
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic.exit"), for: [])
        button.tintColor = UIColor(named: "YPRed")
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor(named: "YPWhite")
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YPGray")
        label.text = "@ekaterina_nov"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YPWhite")
        label.text = "Hello, world!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        updateProfileDetails(profile: profileService.profile)
        addProfileImageServiceObserver()
        updateAvatar()
    }
}

private extension ProfileViewController {
    // MARK: - Update profile
    func addProfileImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {
            return
        }
        fullNameLabel.text = profile.name
        nickNameLabel.text = profile.loginName
        aboutLabel.text = profile.bio
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            profilePhoto.image = UIImage(named: "ic.person.crop.circle.fill")
            return
        }
        
        let processor = RoundCornerImageProcessor(radius: .point(61))
        let pngSerializer = FormatIndicatedCacheSerializer.png
        
        profilePhoto.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic.person.crop.circle.fill"),
            options: [
                .processor(processor),
                .cacheSerializer(pngSerializer),
                .transition(.fade(1))
            ]
        ) { result in
            
            switch result {
            case .success(let value):
                let cacheType: String
                switch value.cacheType {
                case .none:
                    cacheType = "Network"
                case .memory:
                    cacheType = "Memory"
                case .disk:
                    cacheType = "Disk"
                }
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Image - \(value.image)",
                      "Loaded from - \(cacheType)",
                      "Source - \(value.source)",
                      separator: "\n")
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error loading image:",
                      error.localizedDescription)
            }
        }
    }
    
    // MARK: - Logout Alert
    func showLogoutAlert(vc: ProfileViewController) {
        let alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверенные что хотите выйти?",
            buttons: ["Да", "Нет"],
            identifier: "Logout",
            completion: {
                self.profileLogoutService.logout()
            }
        )
        AlertPresenter.showAlert(on: vc, model: alertModel)
    }
    
    //MARK: - Actions
    @objc
    func logoutAction() {
        dismiss(animated: true)
        showLogoutAlert(vc: self)
    }
    
    // MARK: - Constraints
    func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(profileStackView)
        profileStackView.addArrangedSubview(headerStackView)
        profileStackView.addArrangedSubview(fullNameLabel)
        profileStackView.addArrangedSubview(nickNameLabel)
        profileStackView.addArrangedSubview(aboutLabel)
        headerStackView.addArrangedSubview(profilePhoto)
        headerStackView.addArrangedSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    ProfileViewController()
}
