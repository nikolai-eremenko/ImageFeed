//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 13.06.2024.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateProfileDetails(name: String, login: String, bio: String)
    func updateAvatar(with url: URL)
    func showLogoutAlert(model: AlertModel)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    //MARK: - UI Components
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 3
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
    
    private lazy var profilePhotoImageView: UIImageView = {
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
        button.accessibilityIdentifier = "logoutButton"
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
        
        presenter?.setProfileDetails()
        presenter?.addProfileImageServiceObserver()
        ///  обсервер будет получать нотификации после момента добавления, но может так случиться, что запрос на получение аватарки уже успел завершиться. Поэтому в viewDidLoad  также пытаемся обновить аватарку.
        presenter?.setAvatarURL()
    }

    // MARK: - Avatar
    func updateAvatar(with url: URL) {
        let processor = RoundCornerImageProcessor(radius: .point(61))
        let pngSerializer = FormatIndicatedCacheSerializer.png
        let placeholderImage = UIImage(named: "ic.person.crop.circle.fill")
        
        profilePhotoImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
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
                self.profilePhotoImageView.image = placeholderImage
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error loading image:",
                      error.localizedDescription)
            }
        }
    }
    
    // MARK: - Profile
    func updateProfileDetails(name: String, login: String, bio: String) {
        fullNameLabel.text = name
        nickNameLabel.text = login
        aboutLabel.text = bio
    }
    
    // MARK: - Logout Alert
    func showLogoutAlert(model: AlertModel) {
        AlertPresenter.showAlert(on: self, model: model)
    }
}

private extension ProfileViewController {
    
    //MARK: - Actions
    @objc
    func logoutAction() {
        presenter?.didTapLogoutButton()
    }
    
    // MARK: - Constraints
    func setupViews() {
        view.backgroundColor = .ypBlack
        view.addSubview(profileStackView)
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        profileStackView.addArrangedSubview(headerStackView)
        profileStackView.addArrangedSubview(fullNameLabel)
        profileStackView.addArrangedSubview(nickNameLabel)
        profileStackView.addArrangedSubview(aboutLabel)
        headerStackView.addArrangedSubview(profilePhotoImageView)
        headerStackView.addArrangedSubview(logoutButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    ProfileViewController()
}
