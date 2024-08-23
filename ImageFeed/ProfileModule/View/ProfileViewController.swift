//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 13.06.2024.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func showLogoutAlert(model: AlertModel)
    func dismissView()
    func updateProfileDetails(with model: Profile)
    func updateProfileImage(with stringURL: String?)
    func failureProfileDetails(error: Error)
    func failureProfileImage(error: Error)
}

final class ProfileViewController: UIViewController {
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
        imageView.image = UIImage(named: "ic.person.crop.circle.fill")
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
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YPGray")
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YPWhite")
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupViews()
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

extension ProfileViewController: ProfileViewControllerProtocol {
    
    // MARK: - Profile
    func updateProfileDetails(with model: Profile) {
        fullNameLabel.text = model.name
        nickNameLabel.text = model.loginName
        aboutLabel.text = model.bio
    }
    
    func failureProfileDetails(error: any Error) {
        // TODO: - Show alert
        print("DEBUG",
              "[\(String(describing: self)).\(#function)]:",
              "ProfileService error -",
              error.localizedDescription,
              separator: "\n")
    }
    
    // MARK: - ProfileImage
    func updateProfileImage(with stringURL: String?) {
        guard let stringURL,
              let url = URL(string: stringURL) else {
            return
        }
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
    
    func failureProfileImage(error: any Error) {
        profilePhotoImageView.image = UIImage(named: "ic.person.crop.circle.fill")
        print("DEBUG",
              "[\(String(describing: self)).\(#function)]:",
              "ProfileImageService error ->",
              error.localizedDescription,
              separator: "\n")
    }
    
    // MARK: - Dismiss View
    func dismissView() {
        dismiss(animated: true)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    ProfileViewController()
}
