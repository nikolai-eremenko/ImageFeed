//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 02.06.2024.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject, ImagesListCellDelegate {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func showLikeErrorAlert(model: AlertModel)
    func showSingleImage(vc: UIViewController)
    func tableViewInsertRows(at indexPaths: [IndexPath])
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    //MARK: - UI Components
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = presenter
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        setupUI()
        setupConstraints()
        presenter?.viewDidLoad()
    }
    
    func tableViewInsertRows(at indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func showSingleImage(vc: UIViewController) {
        present(vc, animated: true)
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

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.getPhoto(indexPath: indexPath) else { return 200 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectImage(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let photosCount = presenter?.getPhotosCount() else { return }
        if indexPath.row + 1 == photosCount {
            presenter?.fetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.didTapLikeButton(indexPath: indexPath) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let isLiked):
                cell.setIsLiked(isLiked)
            case .failure(let error):
                guard let model = self.presenter?.getLikeErrorAlert() else { return }
                self.showLikeErrorAlert(model: model)
                
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Like error:",
                      error.localizedDescription,
                      separator: "\n")
            }
        }
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    ImagesListViewController()
}
