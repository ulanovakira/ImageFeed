//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Кира on 21.06.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var imageURL: URL?
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let uiActivityIndicator = UIActivityViewController(activityItems: [ image ],
                                                           applicationActivities: nil
        )
        present(uiActivityIndicator, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        singleImageLoad()
    }
    
    private func singleImageLoad() {
        UIBlockingProgressHUD.show()
        self.imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
            let alertController = UIAlertController(title: "Что-то пошло не так",
                                                    message: "Попробуйте еще раз",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Отмена", style: .default))
            alertController.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] result in
                guard let self = self else { return }
                self.singleImageLoad()
            }))
            present(alertController, animated: true)
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
