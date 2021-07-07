//
//  CarouselCellCollectionViewCell.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/6/21.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    var model : CarouselElement? {
        didSet {
            DispatchQueue.main.async {
                self.configureCell()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        resetCell()
        if(model?.image == nil) {
            modelDownloadImage()
        }
        else{
            fillViewsWithModel()
        }
    }
    
    fileprivate func fillViewsWithModel() {
        imageView.image = model?.image
    }
    
    fileprivate func resetCell() {
        self.activityIndicator.isHidden = false
        self.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        imageView.image = nil
    }
    
    
    fileprivate func modelDownloadImage() {
        ImageDownloader.downloadImage(imageUrl: model?.imageUrl ?? "") { (downloadedImage) in
            self.model?.image = downloadedImage
            DispatchQueue.main.async {
                self.fillViewsWithModel()
            }
        }
    }
}

