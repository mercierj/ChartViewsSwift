//
// ChartGridView.swift
//  ChartViewsSwift
//
//  Created by Joachim Mercier on 10/01/2022.
//

import UIKit

class ChartGridView : UIView {
    internal var styled = false
    
    /// Contains horizontal lines
    private let gridLayer: CALayer = CALayer()
    
    var leftDataEntries: [Double]? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var rightDataEntries: [Double]? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    private func setupView() {
        self.layer.addSublayer(gridLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gridLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        gridLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height:  self.frame.size.height)
        gridLayer.backgroundColor = UIColor.clear.cgColor
        drawHorizontalLines()
    }
    
    
    
    /**
     Create horizontal lines (grid lines) and show the value of each line
     */
    private func drawHorizontalLines() {
        guard let dataEntries = leftDataEntries else {
            return
        }
        var gridValues: [CGFloat]? = nil
        if dataEntries.count < 4 && dataEntries.count > 0 {
            gridValues = [0, 1]
        } else if dataEntries.count >= 4 {
            gridValues = [0, 0.25, 0.5, 0.75, 1]
        }
        if let gridValues = gridValues {
            for value in gridValues {
                let height = value * gridLayer.frame.size.height
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 34, y: height))
                path.addLine(to: CGPoint(x: gridLayer.frame.size.width - 34, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = UIColor(named: "LightBlue")!.cgColor
                lineLayer.lineWidth = 0.75
                if (value > 0.0 && value < 1.0) {
                    lineLayer.lineDashPattern = [4, 4]
                }
                gridLayer.addSublayer(lineLayer)
                addTextLayers(value, height: height)
            }
        }
    }
    
    private func addTextLayers(_ value: Double, height: CGFloat){
        if let leftDataEntries = leftDataEntries {
            var minMaxGap:CGFloat = 0
            var lineValue:Int = 0
            let min = 0.0
            if let max = leftDataEntries.max()
            {
                minMaxGap = CGFloat(max - min)
                lineValue = Int((1-value) * minMaxGap) + Int(min)
            }
            addTextLayer(lineValue: lineValue, height: height,left: true)
        }
        
        if let rightDataEntries = rightDataEntries {
            var minMaxGap:CGFloat = 0
            var lineValue:Int = 0
            let min = 0.0
            if let max = rightDataEntries.max()
            {
                minMaxGap = CGFloat(max - min)
                lineValue = Int((1-value) * minMaxGap) + Int(min)
            }
            addTextLayer(lineValue: lineValue, height: height, left: false)
        }
    }
    
    private func addTextLayer(lineValue: Int, height: CGFloat, left: Bool){
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: left ? 0 : self.frame.width - 25, y: height - 10, width: 50, height: 16)
        textLayer.alignmentMode =  .left
        textLayer.foregroundColor = UIColor(named: "DarkBlue")!.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = UIFont(name: "TrebuchetMS-Bold", size: 12)
        textLayer.fontSize = 12
        textLayer.string = "\(lineValue)"
        gridLayer.addSublayer(textLayer)
    }
}
