//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 02.06.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    //MARK: - Properties
    private var photos: [Photo] = []

    private let imagesListService = ImagesListService()
    private var imageListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    //MARK: - UI Components
    private lazy var tableView: UITableView = {
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
        
        overrideUserInterfaceStyle = .dark
        
        setupUI()
        setupConstraints()
        
        addImageListServiceObserver()
        
        imagesListService.fetchPhotosNextPage()
    }
}

private extension ImagesListViewController {
    // MARK: - UI
    func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
      
    @objc
    func updateTableViewAnimated() {
        DispatchQueue.main.async {
            let oldCount = self.photos.count
            let newCount = self.imagesListService.photos.count
            if oldCount != newCount {
                self.photos = self.imagesListService.photos
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                self.tableView.performBatchUpdates {
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
    
    func addImageListServiceObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }

            self.updateTableViewAnimated()
        }
    }
    
    // MARK: - Constraints
    func setupConstraints() {
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
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell {
            
            let photo = photos[indexPath.row]
            cell.delegate = self
            cell.selectionStyle = .none
            cell.configure(with: photo, tableView: tableView, indexPath: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        guard let fullImageURL = URL(string: photos[indexPath.row].fullImageURL) else { return }
        
        viewController.fullImageURL = fullImageURL
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            
            switch result {
            case .success:
                // Синхронизируем массив картинок с сервисом
                DispatchQueue.main.async {
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                }
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                // TODO: Показать ошибку с использованием UIAlertController
                print(error)
            }
        }
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    ImagesListViewController()
}
