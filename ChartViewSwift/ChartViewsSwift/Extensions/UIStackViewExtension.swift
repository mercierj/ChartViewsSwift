//
// UIStackViewExtension.swift
//  ChartViewsSwift
//
//  Created by Joachim Mercier on 25/11/2022.
//

import UIKit

extension UIStackView{
    func removeAllArrangedSubviews() {
            
            let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
                self.removeArrangedSubview(subview)
                return allSubviews + [subview]
            }
            
            // Deactivate all constraints
            NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
            
            // Remove the views from self
            removedSubviews.forEach({ $0.removeFromSuperview() })
        }
}
