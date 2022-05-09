//
//  UIButton+extension.swift
//  BookTDDSample
//
//  Created by Arrr Park on 09/05/2022.
//
import UIKit

extension UIButton {
    @discardableResult
    func setImageButton(_ image: UIImage?) -> UIButton {
        setImage(image, for: .normal)
        tintColor = .black
        imageView?.contentMode = .scaleAspectFit
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        return self
    }
}
