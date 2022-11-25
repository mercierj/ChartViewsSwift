//
// ViewController.swift
//  ChartViewsSwitExample
//
//  Created by Joachim Mercier on 09/05/2022.
//

import UIKit
import ChartViewsSwift

class ViewController: UIViewController {
    @IBOutlet private weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let values = generateRandomEntries()
        self.barChartView.setSimpleValues(values: values, max: values.max()!)
    }


    private func generateRandomEntries() -> [Double] {
            var result: [Double] = []
            for _ in 0..<12 {
                let value = Int(arc4random() % 500)
                result.append(Double(value))
            }
            return result
        }
  
    
}

