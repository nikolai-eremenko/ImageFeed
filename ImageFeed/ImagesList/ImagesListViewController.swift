//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 02.06.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    //MARK: - Properties
    private let images: [String] = Array(0..<20).map{ "\($0)" }
    
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
    }
}

private extension ImagesListViewController {
    // MARK: - UI
    func setupUI() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: images[indexPath.row]) else {
            return
        }
        
        let isLiked = indexPath.row % 2 == 0
        
        let model = ImageCellModel(
            cardImageView: image,
            dateLabel: dateFormatter.string(from: Date()),
            likeButtonColor: isLiked ? .ypRed : .ypWhiteAlpha50
        )
        
        cell.configure(with: model)
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
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell {
            configCell(for: cell, with: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // вызывается прямо перед тем, как ячейка таблицы будет показана на экране.
    // В этом методе можно проверить условие indexPath.row + 1 == photos.count,
    // и если оно верно — вызывать fetchPhotosNextPage().
    // Отметим, что этот метод может вызываться для одной и той же ячейки множество раз (иногда десятки раз).
    // Поэтому нужно сделать так, чтобы многократные вызовы fetchPhotosNextPage() были «дешёвыми» по ресурсам и не приводили к прерыванию текущего сетевого запроса.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: images[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        guard let image = UIImage(named: images[indexPath.row]) else { return }
        viewController.image = image
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    ImagesListViewController()
}
