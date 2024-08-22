//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 13.06.2024.
//

import UIKit
import Kingfisher

protocol SingleImageViewControllerProtocol: AnyObject {
    var presenter: SingleImageViewPresenterProtocol? { get set }
    func showFullImage(with imageURL: URL)
}

final class SingleImageViewController: UIViewController, SingleImageViewControllerProtocol{
    var presenter: SingleImageViewPresenterProtocol?
    
//    var fullImageURL: URL?
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    //MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.minimumZoomScale = 0.1
        view.maximumZoomScale = 1.25
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "ic.backward"), for: [])
        view.tintColor = .ypWhite
        view.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var shareButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "ic.share"), for: [])
        view.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        presenter?.viewDidLoad()
    }
    
    func showFullImage(with imageURL: URL) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let imageResult):
                DispatchQueue.main.async {
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                }
            case .failure(let error):
                self.showError(vc: self)
            }
        }
    }
}

private extension SingleImageViewController {
    // MARK: - Error Alert
    func showError(vc: SingleImageViewController) {
        let alertModel = AlertModel(
            title: "Что-то пошло не так!",
            message: "Попробовать ещё раз?",
            buttons: [.cancelButton, .retryButton],
            identifier: "SingleImageError",
            completion: {
//                self.showFullImage()
            }
        )
        AlertPresenter.showAlert(on: vc, model: alertModel)
    }
    
    // MARK: - ScrollView
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    
    // MARK: - Actions
    @objc
    func didTapBackButton() {
        presenter?.didTapBackButton()
    }
    
    @objc
    func didTapShareButton() {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - UI
    func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        scrollView.addSubview(imageView)
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        setupScrollViewConstraints()
        setupImageViewConstraints()
        setupBackButtonConstraints()
        setupShareButtonConstraints()
    }
    
    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupBackButtonConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -8),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupShareButtonConstraints() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 17),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // center image in scroll view after zoom
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max(0, (scrollView.bounds.width - scrollView.contentSize.width) * 0.5)
        let offsetY = max(0, (scrollView.bounds.height - scrollView.contentSize.height) * 0.5)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    SingleImageViewController()
}
