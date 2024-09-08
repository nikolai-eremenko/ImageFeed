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
        imageView.tintColor = .ypGray
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YPGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YPWhite")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameAnimationView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nickAnimationView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var aboutAnimationView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        addLoadingAnimation()
        presenter?.viewDidAppear()
    }
    
    // MARK: - Logout Alert
    func showLogoutAlert(model: AlertModel) {
        AlertPresenter.showAlert(on: self, model: model)
    }
}

private extension ProfileViewController {
    func updateProfileWithPlaceholder() {
        let placeHolderProfile = Profile(username: "Екатерина", name: "Новикова", loginName: "@ekaterina_nov", bio: "Hello, world!")
        updateProfileDetails(with: placeHolderProfile)
    }
    
    //MARK: - Animations
    func addLoadingAnimation() {
        profilePhotoImageView.addLoadingLayer(radius: profilePhotoImageView.frame.width/2)
        
        nameAnimationView.addLoadingLayer(radius: nameAnimationView.frame.height/2)
        nickAnimationView.addLoadingLayer(radius: nickAnimationView.frame.height/2)
        aboutAnimationView.addLoadingLayer(radius: aboutAnimationView.frame.height/2)
    }
    
    func removeLoadingAnimation() {
        nameAnimationView.removeLoadingLayer()
        nickAnimationView.removeLoadingLayer()
        aboutAnimationView.removeLoadingLayer()
        
        nameAnimationView.removeFromSuperview()
        nickAnimationView.removeFromSuperview()
        aboutAnimationView.removeFromSuperview()
    }
    
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
        
        fullNameLabel.addSubview(nameAnimationView)
        nickNameLabel.addSubview(nickAnimationView)
        aboutLabel.addSubview(aboutAnimationView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 70),
            
            fullNameLabel.heightAnchor.constraint(equalToConstant: 18),
            nickNameLabel.heightAnchor.constraint(equalToConstant: 18),
            aboutLabel.heightAnchor.constraint(equalToConstant: 18),
            
            nameAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            nameAnimationView.heightAnchor.constraint(equalToConstant: 18),
            nickAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24),
            nickAnimationView.heightAnchor.constraint(equalToConstant: 18),
            aboutAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.16),
            aboutAnimationView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    // MARK: - Profile
    func updateProfileDetails(with model: Profile) {
        fullNameLabel.text = model.name
        nickNameLabel.text = model.loginName
        aboutLabel.text = model.bio
        
        removeLoadingAnimation()
    }
    
    func failureProfileDetails(error: any Error) {
        // TODO: - Show alert
        print("DEBUG",
              "[\(String(describing: self)).\(#function)]:",
              "ProfileService error -",
              error.localizedDescription,
              separator: "\n")
        removeLoadingAnimation()
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
            options: [
                .processor(processor),
                .cacheSerializer(pngSerializer)
            ]
        ) { [weak self] result in
            guard let self else { return }
            
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
            self.profilePhotoImageView.removeLoadingLayer()
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
