//
//  UIViewController+Pokedex.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 08/08/21.
//

import UIKit
import MapKit

extension UIViewController {
    
    static func loadXib<T: UIViewController>() -> T {
        let bundle = Bundle(for: T.self)
        return T(nibName: "\(self)", bundle: bundle)
    }
}

extension MKAnnotationView {
    func applyImage(from url: URL) {
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
                else { return }

            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

extension UIImage {

    func cropped() -> UIImage? {
        let cropRect = CGRect(x: 0, y: 0, width: 44 * scale, height: 44 * scale)

        guard let croppedCGImage = cgImage?.cropping(to: cropRect) else { return nil }

        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
}
