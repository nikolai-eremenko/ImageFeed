//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 28.06.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2Service = OAuth2Service.shared
    
    // MARK: - UI Components
    private lazy var authButton: UIButton = {
        let view = UIButton()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .ypWhite
        view.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        view.setTitleColor(.ypBlack, for: .normal)
        view.setTitle("Войти", for: .normal)
        view.addTarget(self, action: #selector(switchToWebViewController), for: .touchUpInside)
        view.accessibilityIdentifier = "Authenticate"
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic.unsplash")
        view.tintColor = .ypWhite
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
}

private extension AuthViewController {
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        oauth2Service.fetchOAuthToken(code) { result in
            completion(result)
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "YPBlack")
        view.addSubview(logoImageView)
        view.addSubview(authButton)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    // MARK: - Alert
    func showAuthAlert(vc: AuthViewController) {
        let alertModel = AlertModel(
            title: "Что-то пошло не так!",
            message: "Не удалось войти в систему.",
            buttons: [.okButton],
            identifier: "AuthError",
            completion: {
                vc.dismiss(animated: true)
            }
        )
        AlertPresenter.showAlert(on: self, model: alertModel)
    }
    
    // MARK: - Actions
    @objc
    func switchToWebViewController() {
        let webViewViewController = WebViewViewController()
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self
        
        webViewViewController.modalPresentationStyle = .overFullScreen
        present(webViewViewController, animated: true)
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            authButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

// MARK: - AuthViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.delegate?.didAuthenticate(self)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAuthAlert(vc: self)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    AuthViewController()
}
