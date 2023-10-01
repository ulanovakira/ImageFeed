//
//  ViewController.swift
//  ImageFeed
//
//  Created by Кира on 28.05.2023.
//

import UIKit
import Kingfisher

public protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    func updateTableViewAnimated()
}

class ImageListViewController: UIViewController, ImageListViewControllerProtocol, UITableViewDataSource {
    var presenter: ImageListPresenterProtocol?
    
    @IBOutlet private var tableView: UITableView?
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImageListService.shared
    private var photos: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(tableView)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
//        imageListServiceObserver = NotificationCenter.default.addObserver(forName:ImageListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
//            self?.updateTableViewAnimated()
//        }
        let imageListPresenter = ImageListPresenter()
        print("imageListPresenter \(imageListPresenter)")
        self.presenter = imageListPresenter
        imageListPresenter.view = self
        imageListService.fetchPhotosNextPage()
        imageListPresenter.observeNotifications()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            if let url = imageListService.photos[indexPath.row].largeImageURL,
               let imageURL = URL(string: url) {
                viewController.imageURL = imageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tableView.numberOfRows(inSection: 0) {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let url = photos[indexPath.row].thumbImageURL,
           let imageURL = URL(string: url) {
                cell.cellImage.kf.indicatorType = .activity
                cell.cellImage.kf.setImage(with: imageURL,
                                           placeholder: UIImage(named: "stub")) { [weak self] _ in
                    guard let self = self else { return }
                    self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                }
            if let date = photos[indexPath.row].createdAt {
                cell.dateLabel.text = dateFormatter.string(from: date)
                } else {
                    cell.dateLabel.text = ""
                }
            let isLiked = photos[indexPath.row].isLiked == false
            let likeImage = isLiked ? UIImage(named: "likeButtonOff") : UIImage(named: "likeButtonOn")
            cell.likeButton.setImage(likeImage, for: .normal)
            cell.selectionStyle = .none
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView?.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView?.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}


extension ImageListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imageListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                print("Failed to like/unlike")
                self.showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "ОК",
            style: .default))
        
        present(alert, animated: true, completion: nil)
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = imageListService.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
