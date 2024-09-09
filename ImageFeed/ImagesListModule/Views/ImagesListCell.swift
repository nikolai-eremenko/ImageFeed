//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 03.06.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    private let dateFormatter = DateConvertor.shared
        
    //MARK: - UI Components
    private lazy var cellView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    private lazy var cellImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic.scribble.variable")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var gradientView: GradientView = {
        let view = GradientView()
        view.startColor = .ypBlack
        view.endColor = .clear
        view.angle = 90
        
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "ic.like"), for: .normal)
        view.tintColor = .ypWhiteAlpha50
        view.accessibilityIdentifier = "likeButtonIsNotLiked"
        view.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.text = "12/0/2"
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .ypWhite

        return view
    }()
    
    enum FeedCellImageState {
        case loading
        case error
        case finished(UIImage)
    }
    
    var imageState: FeedCellImageState = .loading {
        didSet {
            switch imageState {
            case .loading:
                addLoadingAnimation()
            case .error:
                cellImageView.image = UIImage(named: "ic.scribble.variable")
                removeLoadingAnimation()
            case .finished(let image):
                cellImageView.image = image
                removeLoadingAnimation()
            }
        }
    }
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImageView.kf.cancelDownloadTask()
        cellImageView.image = nil
        likeButton.tintColor = .ypWhiteAlpha50
        dateLabel.text = nil
        likeButton.accessibilityIdentifier = "likeButtonIsNotLiked"
        removeLoadingAnimation()
    }
    
    // MARK: - Cell Config
    func configure(with model: Photo) {
        imageState = .loading
        
        let stringDate: String
        
        if let date = model.createdAt {
            stringDate = dateFormatter.getStringFromDate(from: date)
        } else {
            stringDate = ""
        }

        guard let url = URL(string: model.smallImageURL) else {return}
        
        cellImageView.kf.setImage(with: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let value):
                self.imageState = .finished(value.image)
                
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
                
                self.imageState = .error
            }
        }
        
        dateLabel.text = stringDate
        likeButton.tintColor = model.isLiked ? .ypRed : .ypWhiteAlpha50
        likeButton.accessibilityIdentifier = model.isLiked ? "likeButtonIsLiked" : "likeButtonIsNotLiked"
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.tintColor = isLiked ? .ypRed : .ypWhiteAlpha50
        likeButton.accessibilityIdentifier = isLiked ? "likeButtonIsLiked" : "likeButtonIsNotLiked"
    }
    
    // MARK: - Animations
    func addLoadingAnimation() {
        likeButton.isHidden = true
        dateLabel.isHidden = true
        gradientView.isHidden = true
        layoutIfNeeded()
        cellImageView.addLoadingLayer(radius: cellView.layer.cornerRadius)
    }
    
    func removeLoadingAnimation() {
        likeButton.isHidden = false
        dateLabel.isHidden = false
        gradientView.isHidden = false
        layoutIfNeeded()
        cellImageView.removeLoadingLayer()
    }
}

private extension ImagesListCell {
    // MARK: - Actions
    @objc
    func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setupUI() {
        contentView.backgroundColor = .ypBlack
        contentView.addSubview(cellView)
        cellView.addSubview(cellImageView)
        cellView.addSubview(likeButton)
        cellView.addSubview(gradientView)
        cellView.addSubview(dateLabel)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            cellImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            cellImageView.topAnchor.constraint(equalTo: cellView.topAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            likeButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    let cell = ImagesListCell()
    return cell
}
