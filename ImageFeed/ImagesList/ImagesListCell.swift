//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 03.06.2024.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
        
    //MARK: - UI Components
    private lazy var cellView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var cellImageView: UIImageView = {
        let view = UIImageView()
//        view.image = UIImage(named: "0")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var gradientView: GradientView = {
        let view = GradientView()
        view.startColor = .ypGradient
        view.endColor = .clear
        view.angle = 90
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "ic.like"), for: .normal)
        view.tintColor = .ypWhiteAlpha50
        view.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .ypWhite
//        view.text = "27 августа 2022"
        return view
    }()
    
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
    }
    
    // MARK: - Configuration
    func configure(image: UIImage, date: String, isLiked: Bool) {
        cellImageView.image = image
        dateLabel.text = date
        likeButton.tintColor = isLiked ? .ypRed : .ypWhiteAlpha50
    }
    
    func setIsLiked(_ isLiked: Bool) {
        self.likeButton.tintColor = isLiked ? .ypRed : .ypWhiteAlpha50
    }
}

private extension ImagesListCell {
    
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
    
    // MARK: - Actions
    @objc
    func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
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
