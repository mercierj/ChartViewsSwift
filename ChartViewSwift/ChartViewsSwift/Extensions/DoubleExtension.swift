//
// DoubleExtension.swift
//  ChartViewsSwift
//
//  Created by Joachim Mercier on 09/05/2022.
//

import Foundation

extension Double {

    /// Rounds the double to decimal places value
       func roundToPlaces(toPlaces places:Int) -> Double {
           let divisor = pow(10.0, Double(places))
           return (self * divisor).rounded() / divisor
       }
    
        func toInt() -> Int {
            if self >= Double(Int.min) && self < Double(Int.max) {
                return Int(self)
            } else {
                return Int.max
            }
        }
}
