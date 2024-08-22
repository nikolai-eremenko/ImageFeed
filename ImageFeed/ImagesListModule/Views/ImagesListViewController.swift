//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 02.06.2024.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    var tableView: UITableView { get }
    func showLikeErrorAlert(model: AlertModel)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    var presenter: ImagesListViewPresenterProtocol?
    
    //MARK: - UI Components
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Cell
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        guard let photo = presenter.photos[safeIndex: indexPath.row] else { return }
        
        let stringDate: String
        
        if let date = photo.createdAt {
            stringDate = presenter.dateFormatter.getStringFromDate(from: date)
        } else {
            stringDate = ""
        }

        guard let url = URL(string: photo.smallImageURL) else {return}
        
        cell.cellImageView.kf.indicatorType = .activity
        cell.cellImageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "ic.scribble.variable"),
                              options: [.transition(.fade(1))]) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let value):
                cell.configure(image: value.image, date: stringDate, isLiked: photo.isLiked)
                
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
                      "Image loaded from - \(cacheType)",
                      "Source - \(value.source)",
                      separator: "\n")
                
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error loading image:",
                      error.localizedDescription)
                guard let placeholder = UIImage(named: "ic.scribble.variable") else {return}
                cell.configure(image: placeholder, date: stringDate, isLiked: photo.isLiked)
            }
        }
    }
    
    // MARK: - Alerts
    func showLikeErrorAlert(model: AlertModel) {
        AlertPresenter.showAlert(on: self, model: model)
    }
    
    // MARK: - UI
    private func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell {
            cell.delegate = self
            cell.selectionStyle = .none
            configCell(for: cell, with: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photos[safeIndex: indexPath.row] else { return 200 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        guard let imageURL = URL(string: presenter.photos[indexPath.row].fullImageURL) else { return }
        
        presenter.tapOnImage(imageURL: imageURL)
        
//        let viewController = SingleImageViewController()
//        viewController.fullImageURL = fullImageURL
//        viewController.modalPresentationStyle = .fullScreen
//        present(viewController, animated: true)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        presenter?.didTapLikeButton(cell: cell)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    ImagesListViewController()
}
