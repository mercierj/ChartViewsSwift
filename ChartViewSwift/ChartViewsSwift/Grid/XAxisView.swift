//
// XAxisView.swift
//  ChartViewsSwift
//
//  Created by Joachim Mercier on 12/01/2022.
//

import UIKit

class XAxisView: UIView{

    private var mainStackView : UIStackView!
    var labelsStrings : [String] = [] {
        didSet {
            setNeedsLayout()
        }
    }
    var double = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        mainStackView = UIStackView()
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.axis = .horizontal
        mainStackView.spacing = Utils.barSpacing
        self.addSubview(mainStackView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainStackView.frame = self.bounds
        mainStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        for string in labelsStrings {
            let stackView = UIStackView()
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            let label = UILabel()
            label.font = UIFont(name: "TrebuchetMS-Bold", size: 12)
            label.textColor = UIColor(named: "DarkBlue")!
            label.text = string
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
            if (double){
                let emptyView = UIView()
                emptyView.backgroundColor = .clear
                stackView.addArrangedSubview(emptyView)
            }
            mainStackView.addArrangedSubview(stackView)
        }
    }
}
