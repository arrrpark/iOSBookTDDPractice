//
//  UIImage+Extension.swift
//  BookTDDSample
//
//  Created by Arrr Park on 09/05/2022.
//

import UIKit

extension UIImage {
    static func equal(lhs: UIImage?, rhs: UIImage?) -> Bool {
        if lhs == nil, rhs == nil {
            return true
        } else if lhs == nil && rhs != nil || lhs != nil && rhs == nil {
            return false
        } else {
            return lhs === rhs || lhs?.pngData() == rhs?.pngData()
        }
    }
}
