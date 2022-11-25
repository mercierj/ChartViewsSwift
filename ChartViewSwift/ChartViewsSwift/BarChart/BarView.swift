//
// BarView.swift
//  ChartViewsSwift
//
//  Created by Joachim Mercier on 07/01/2022.
//

import UIKit

class BarView: UIView{
    internal var styled = false

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
   
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (!styled) {
            styled = true
            self.layer.cornerRadius = self.frame.width / 2
            //self.layer.applySketchShadow(color: UIColor(named: "DarkBlue")!, alpha: 0.15, x: 0, y: 0, blur: 4, spread: 0)
        }
    }
}
