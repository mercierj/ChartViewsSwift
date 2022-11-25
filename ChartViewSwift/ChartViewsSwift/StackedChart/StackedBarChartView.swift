//
// StackedBarChartView.swift
//  ChartViewsSwift
//
//  Created by Joachim Mercier on 10/01/2022.
//

import UIKit


class StackedBarChartView: UIView{
    private var mainStackView : UIStackView!
    var bubbleColor : UIColor = UIColor.gray
    var bubbleFont: UIFont = UIFont.systemFont(ofSize: 9)
    private var hasBubble = false
    private var values : [Double]?
    private var percentages : [[Double]]?
    private var partValues : [[Double]]?

    private var max : Double?
    private var colors : [UIColor] = []
    
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
        mainStackView.axis = .horizontal
        mainStackView.alignment =  .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 0
        self.addSubview(mainStackView)
    }

    
    private func drawStackedBars(){
        guard let values = values, let max = self.max, self.colors.count > 0 else {
            return
        }
        mainStackView.frame = self.bounds
        mainStackView.removeAllArrangedSubviews()
        let requiredViewCount = values.count - 1
        for i in 0 ... requiredViewCount {
            let stackedBarView = UIView()
            stackedBarView.translatesAutoresizingMaskIntoConstraints = false
            stackedBarView.accessibilityIdentifier = "stackedBarView\(i)"
            let barStackViewContainer = UIView()
            barStackViewContainer.layer.cornerRadius = self.frame.width / CGFloat(values.count) * 0.35 / 2
            barStackViewContainer.layer.masksToBounds = true
            barStackViewContainer.accessibilityIdentifier = "barStackViewContainer\(i)"
            barStackViewContainer.translatesAutoresizingMaskIntoConstraints = false
            let barStackView = UIStackView()
            barStackView.axis = .vertical
            barStackView.distribution = .fill
            barStackView.spacing = 0
            barStackView.translatesAutoresizingMaskIntoConstraints = false
            barStackView.accessibilityIdentifier = "barStackView\(i)"
            barStackViewContainer.addSubview(barStackView)
            stackedBarView.addSubview(barStackViewContainer)
            mainStackView.addArrangedSubview(stackedBarView)
            for j in (0 ... colors.count - 1).reversed() {
                let barViewPart = UIView()
                barViewPart.backgroundColor = colors[j]
                barViewPart.accessibilityIdentifier = "barViewPart\(i)-\(j)"
                barStackView.addArrangedSubview(barViewPart)
                NSLayoutConstraint.activate([
                    barViewPart.heightAnchor.constraint(equalToConstant: 0)
                ])
            }
            NSLayoutConstraint.activate([
                barStackViewContainer.bottomAnchor.constraint(equalTo: stackedBarView.bottomAnchor),
                barStackViewContainer.centerXAnchor.constraint(equalTo: stackedBarView.centerXAnchor),
                barStackViewContainer.widthAnchor.constraint(equalTo: stackedBarView.widthAnchor, multiplier: 0.35),
                barStackView.bottomAnchor.constraint(equalTo: barStackViewContainer.bottomAnchor),
                barStackView.topAnchor.constraint(equalTo: barStackViewContainer.topAnchor),
                barStackView.leftAnchor.constraint(equalTo: barStackViewContainer.leftAnchor),
                barStackView.rightAnchor.constraint(equalTo: barStackViewContainer.rightAnchor),
            ])
        }
      
        for (index, stackedBarView) in mainStackView.arrangedSubviews.enumerated() {
            guard let partItems = percentages != nil ? percentages : partValues,  index < partItems.count, partItems[index].count >= colors.count, stackedBarView.subviews.count >= 1 else { return }
                let barStackViewContainer = stackedBarView.subviews[0]
                guard barStackViewContainer.subviews.count >= 1, let barStackView = barStackViewContainer.subviews[0] as? UIStackView else { return
                }
                let count = barStackView.arrangedSubviews.count - 1
                for (barIdx, barViewPart) in barStackView.arrangedSubviews.enumerated() {
                    var barValue = partItems[index][count - barIdx]
                    var height : Double = 0
                    let heightWithoutSpacing = Double(frame.height)
                    if (partValues != nil){
                        if (barValue > 1){
                            barValue = Double(barValue.toInt())
                        }
                        height =  barValue / max * heightWithoutSpacing
                    }else{
                        let indexValue = self.values![index]
                        let finalValue = ((barValue * indexValue) / 100).roundToPlaces(toPlaces: 1)
                        height = finalValue / max * heightWithoutSpacing
                        print("indexValue = \(indexValue), barValue = \(barValue), finalValue = \(finalValue), height = \(height)")
                    }
                    setBarHeight(index: index, barIdx: barIdx, barViewPart, height)
                }
            if (hasBubble){
                var indexValue = self.values![index]
                if (indexValue > 1){
                    indexValue = Double(indexValue.toInt())
                }
                setBubble(barContainerView: stackedBarView, barView: barStackViewContainer, value: indexValue)
            }
        }
    }
    
    private func setBubble(barContainerView: UIView, barView: UIView, value: Double){
        let valueLabel = UILabel()
        valueLabel.font = bubbleFont
        valueLabel.textColor = .white
        valueLabel.backgroundColor = bubbleColor
        valueLabel.text =  (value >= 1  || value == 0) ? "\(value.toInt())" : "\(value)"
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        barContainerView.addSubview(valueLabel)
        valueLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
        valueLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: barContainerView.centerXAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -7).isActive = true
        valueLabel.roundCorners(radius: 11)
    }

    func setValues(values : [Double], percentages : [[Double]], max: Double, colors: [UIColor], hasBubble: Bool = false){
        mainStackView.frame = self.bounds
        mainStackView.removeAllArrangedSubviews()
        self.max = max
        self.colors = colors
        self.hasBubble = hasBubble
        self.values = values
        self.percentages = percentages
        self.partValues = nil
        self.drawStackedBars()
    }
    
    func setValues(values : [Double], partValues : [[Double]], max: Double, colors: [UIColor], hasBubble: Bool = false){
        mainStackView.frame = self.bounds
        mainStackView.removeAllArrangedSubviews()
        self.max = max
        self.colors = colors
        self.hasBubble = hasBubble
        self.values = values
        self.partValues = partValues
        self.percentages = nil
        self.drawStackedBars()
    }
    
    private func setBarHeight(index: Int, barIdx: Int, _ subview: UIView, _ height: Double){
        subview.isHidden = height == 0
        guard height > 0 else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(barIdx) * 0.1, execute: {
            UIView.animate(withDuration: 0.8) { [weak self] in
                _ = subview.heightConstraint!.constant = height
                self?.layoutIfNeeded()
            }
        })
    }
    
}
