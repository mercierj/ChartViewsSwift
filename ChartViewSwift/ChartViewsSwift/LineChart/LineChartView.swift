//
// LineChartView.swift
//  ChartViewsSwift
//
//  Created by Joachim Mercier on 10/01/2022.
//

import UIKit

enum LineCharType{
    case REGULAR
    case LIGHT
}

struct PointEntry {
    let value: Int
}

extension PointEntry: Comparable {
    static func <(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value < rhs.value
    }
    static func ==(lhs: PointEntry, rhs: PointEntry) -> Bool {
        return lhs.value == rhs.value
    }
}

class LineChartView: UIView {
    
    
    /// preseved space at top of the chart
    let topSpace: CGFloat = 0.0
    
    /// preserved space at bottom of the chart to show labels along the Y axis
    let bottomSpace: CGFloat = 0.0
    
    /// The top most horizontal line in the chart will be 10% higher than the highest value in the chart
    let topHorizontalLine: CGFloat = 1

    /// Active or desactive animation on dots
    var animateDots: Bool = true

    /// Active or desactive dots
    var showDots: Bool = true

    /// Dot inner Radius
    var innerRadius: CGFloat = 7

    /// Dot outer Radius
    var outerRadius: CGFloat = 10
    
    var dataEntries: [Double]? {
        didSet {
            clean()
            self.setNeedsLayout()
        }
    }
    
    var lineChartType : LineCharType = .REGULAR
    
    /// Contains the main line which represents the data
    private let dataLayer: CALayer = CALayer()
    
    /// Contains dataLayer
    private let mainLayer: CALayer = CALayer()
    
    /// Contains mainLayer and label for each data entry
    private let mainView: UIView = UIView()
    
    /// An array of CGPoint on dataLayer coordinate system that the main line will go through. These points will be calculated from dataEntries array
    private var dataPoints: [CGPoint]?
    
    var mainColor : UIColor = .red

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
        mainView.layer.masksToBounds = false
        mainLayer.addSublayer(dataLayer)
        mainView.layer.addSublayer(mainLayer)
        self.addSubview(mainView)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        self.alpha = lineChartType == .REGULAR ? 1 : 0.4
        mainView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        clean()
        if let dataEntries = dataEntries {
            mainLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            dataLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height:  self.frame.size.height)
            dataPoints = convertDataEntriesToPoints(entries: dataEntries)
            if showDots { drawDots() }
            drawChart()
        }
    }
    
    /**
     Convert an array of PointEntry to an array of CGPoint on dataLayer coordinate system
     */
    private func convertDataEntriesToPoints(entries: [Double]) -> [CGPoint] {
        let max = entries.max()!
            
        var result: [CGPoint] = []
        
        for i in 0..<entries.count {
            let halfBarWidth = (lineChartType == .REGULAR ? (self.frame.width / Double(entries.count) / 4.0) : (self.frame.width / Double(entries.count) * 3 / 4))
            let height = self.frame.height - (CGFloat(entries[i]) / max  * self.frame.height)
            let point = CGPoint(x: CGFloat(i) * (self.frame.width / CGFloat(entries.count)) + halfBarWidth, y: height)
            result.append(point)
        }
        return result
    }
    
    /**
     Draw a zigzag line connecting all points in dataPoints
     */
    private func drawChart() {
        if let dataPoints = dataPoints,
            dataPoints.count > 0,
            let path = createPath() {
            CATransaction.begin()
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor = mainColor.cgColor
            lineLayer.lineWidth = 1.5
            lineLayer.fillColor = UIColor.clear.cgColor
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration  = 2
            animation.autoreverses = false
            animation.repeatCount = .zero
            lineLayer.add(animation, forKey: "myStroke")
            CATransaction.commit()
            dataLayer.addSublayer(lineLayer)

        }
    }

    /**
     Create a zigzag bezier path that connects all points in dataPoints
     */
    private func createPath() -> UIBezierPath? {
        guard let dataPoints = dataPoints, dataPoints.count > 0 else {
            return nil
        }
        let path = UIBezierPath()
        path.move(to: dataPoints[0])
        
        for i in 1..<dataPoints.count {
            path.addLine(to: dataPoints[i])
        }
        return path
    }
    
    
    private func clean() {
        mainLayer.sublayers?.forEach({
            if $0 is CATextLayer || $0 is DotCALayer {
                $0.removeFromSuperlayer()
            }
        })
        dataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
    /**
     Create Dots on line points
     */
    private func drawDots() {
        var dotLayers: [DotCALayer] = []
        if let dataPoints = dataPoints {
            for (index, dataPoint) in dataPoints.enumerated() {
                let xValue = dataPoint.x - outerRadius/2
                let yValue = dataPoint.y - outerRadius / 2
                let dotLayer = DotCALayer()
                dotLayer.dotInnerColor = UIColor.white
                dotLayer.innerRadius = innerRadius
                dotLayer.backgroundColor = mainColor.cgColor
                dotLayer.cornerRadius = outerRadius / 2
                dotLayer.opacity = animateDots ? 0 : 1
                dotLayer.frame = CGRect(x: xValue, y: yValue, width: outerRadius, height: outerRadius)
                dotLayers.append(dotLayer)

                mainLayer.addSublayer(dotLayer)

                if animateDots {
                    let duration = Float(2.0 / Float(dataPoints.count))
                    let delay = TimeInterval(Float(index) * duration)
                    print(delay)
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                        let anim = CABasicAnimation(keyPath: "opacity")
                        anim.duration =  TimeInterval(duration)
                        anim.fromValue = 0
                        anim.toValue = 1
                        anim.fillMode = .both
                        anim.isRemovedOnCompletion = false
                        dotLayer.add(anim, forKey: "opacity")
                    })
                }
            }
        }
    }
}
