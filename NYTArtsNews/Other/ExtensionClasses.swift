//
//  ExtensionClasses.swift
//  NYTArtsNews
//
//  Created by Mac Mini  on 7/7/21.
//

import UIKit

extension UIImageView
{
    func downloadFrom(link:String?, contentMode mode: UIView.ContentMode)
    {
        contentMode = mode
        if link == nil
        {
            self.image = UIImage(named: "default")
            return
        }
        if let url = NSURL(string: link!)
        {
            print("\nstart download: \(url.lastPathComponent!)")
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) -> Void in
                guard let data = data, error == nil else {
                    print("\nerror on download \(String(describing: error))")
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    print("\ndownload completed \(url.lastPathComponent!)")
                    self?.image = UIImage(data: data)
                    self?.setNeedsLayout()
                    self?.layoutSubviews()
                }
            }).resume()
        }
        else
        {
            self.image = UIImage(named: "default")
        }
    }
}
