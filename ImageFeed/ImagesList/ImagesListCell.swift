//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Кира on 04.06.2023.
//

import Foundation
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    

    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    var fullSizeImageView = {
        let fullSizeImageView = UIImageView()
        return fullSizeImageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        fullSizeImageView.kf.cancelDownloadTask()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        fullSizeImageView.kf.indicatorType = .activity
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setIsLiked(isLiked: Bool) {
        var likeImage: UIImage
        if isLiked {
            likeImage = UIImage(named: "likeButtonOn")!
        } else {
            likeImage = UIImage(named: "likeButtonOff")!
        }
        likeButton.setImage(likeImage, for: .normal)
    }
}
