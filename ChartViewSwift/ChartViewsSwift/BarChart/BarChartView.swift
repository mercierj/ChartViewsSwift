//
// BarChartView.swift
//  EspaceFraicheur
//
//  Created by Joachim Mercier on 07/01/2022.
//

import Foundation
import UIKit

class BarChartView: UIView{
    private var mainStackView : UIStackView!
    var mainColor : UIColor = UIColor.gray
    var bubbleColor : UIColor =  UIColor.red
    var bubbleFont : UIFont = UIFont.systemFont(ofSize: 9)

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
        mainStackView.spacing = 0
        self.addSubview(mainStackView)
    }
    
    
    func setValues(values: [Double], max : Double, hasBubble: Bool = false, hasAnimal: Bool = false){
        mainStackView.distribution = .fillEqually
        mainStackView.frame = self.bounds
        mainStackView.removeAllArrangedSubviews()
        self.layer.removeAllAnimations()
        var animateIdx = 0
        for value in values {
            let barContainerView = UIView()
            let barView = BarView()
            barView.translatesAutoresizingMaskIntoConstraints = false
            barContainerView.addSubview(barView)
            barView.backgroundColor = self.mainColor
            barView.widthAnchor.constraint(equalTo: barContainerView.widthAnchor, multiplier: 0.35).isActive = true
            barView.centerXAnchor.constraint(equalTo: barContainerView.centerXAnchor).isActive = true
            barView.bottomAnchor.constraint(equalTo: barContainerView.bottomAnchor).isActive = true
            let heightAnchor = barView.heightAnchor.constraint(equalTo: barContainerView.heightAnchor, multiplier: 0.001)
            heightAnchor.isActive = true
            if hasBubble, value >= 0{
                setBubble(barContainerView: barContainerView, barView: barView, value: value)
            }
            mainStackView.addArrangedSubview(barContainerView)
            animateIdx = value > 0 ? animateIdx + 1 : animateIdx
            let multiplier =  (1000 * (value / max)) / 1000
            guard multiplier > 0 else {
                continue
            }
            barView.layer.removeAllAnimations()
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(animateIdx) * 0.1, execute: {
                UIView.animate(withDuration: 0.8) { [weak self] in
                    _ = heightAnchor.setMultiplier(multiplier)
                    self?.layoutIfNeeded()
                }
            })
        }
    }
    
    func setMultiValues(multiValues: [[Double]], max : Double, colors: [UIColor], hasBubble: Bool = false){
       mainStackView.distribution = .equalSpacing
       mainStackView.frame = self.bounds
       mainStackView.removeAllArrangedSubviews()
       self.layer.removeAllAnimations()
       var animateIdx = 0
       for arr in multiValues {
           let barStackView = UIStackView()
           barStackView.axis = .horizontal
           barStackView.distribution = .fillEqually
           barStackView.spacing = 2
           barStackView.translatesAutoresizingMaskIntoConstraints = false
           for (index, value) in arr.enumerated() {
           let barContainerView = UIView()
           let barView = BarView()
           barView.translatesAutoresizingMaskIntoConstraints = false
           barContainerView.addSubview(barView)
           barView.backgroundColor = colors[index]
           barView.widthAnchor.constraint(equalToConstant: 5).isActive = true
           barView.leftAnchor.constraint(equalTo: barContainerView.leftAnchor).isActive = true
           barView.rightAnchor.constraint(equalTo: barContainerView.rightAnchor).isActive = true
           barView.centerXAnchor.constraint(equalTo: barContainerView.centerXAnchor).isActive = true
           barView.bottomAnchor.constraint(equalTo: barContainerView.bottomAnchor).isActive = true
           let heightAnchor = barView.heightAnchor.constraint(equalTo: barContainerView.heightAnchor, multiplier: 0.001)
           heightAnchor.isActive = true
           if hasBubble, value >= 0{
               setBubble(barContainerView: barContainerView, barView: barView, value: value)
           }
           barStackView.addArrangedSubview(barContainerView)
           animateIdx = value > 0 ? animateIdx + 1 : animateIdx
           let multiplier =  (1000 * (value / max)) / 1000
           guard multiplier > 0 else {
               continue
           }
           barView.layer.removeAllAnimations()
           DispatchQueue.main.asyncAfter(deadline: .now() + Double(animateIdx) * 0.1, execute: {
               UIView.animate(withDuration: 0.8) { [weak self] in
                   _ = heightAnchor.setMultiplier(multiplier)
                   self?.layoutIfNeeded()
               }
           })
           }
           mainStackView.addArrangedSubview(barStackView)
       }
    }
   
    
    private func setBubble(barContainerView: UIView, barView: UIView, value: Double){
        let valueLabel = UILabel()
        valueLabel.font = bubbleFont
        valueLabel.textColor = .white
        valueLabel.backgroundColor = bubbleColor
        valueLabel.text = "\(value.toInt())"
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        barContainerView.addSubview(valueLabel)
        valueLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
        valueLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: barContainerView.centerXAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -7).isActive = true
        valueLabel.roundCorners(radius: 11)
    }
   
}
