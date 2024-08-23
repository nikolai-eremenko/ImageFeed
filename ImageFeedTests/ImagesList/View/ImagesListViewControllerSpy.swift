//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import UIKit
import Kingfisher
@testable import ImageFeed

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
//    var isTableViewInsertRowsCalled = false
    
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
    
//    //MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        overrideUserInterfaceStyle = .dark
//        
//        setupUI()
//        setupConstraints()
//        presenter?.viewDidLoad()
//    }
    
    // MARK: - Cell
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.getPhoto(indexPath: indexPath) else { return }
        
        let stringDate: String
        
        if let date = photo.createdAt {
            stringDate = presenter?.getStringFromDate(from: date) ?? ""
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
    
    func tableViewInsertRows(at indexPaths: [IndexPath]) {
//        isTableViewInsertRowsCalled = true
//        tableView.performBatchUpdates {
//            tableView.insertRows(at: indexPaths, with: .automatic)
//        } completion: { _ in }
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
extension ImagesListViewControllerSpy: UITableViewDelegate {
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
extension ImagesListViewControllerSpy: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
    }
}
