//
// XAxisEnum.swift
//  ChartViewsSwift
//
//  Created by Joachim Mercier on 12/01/2022.
//

import Foundation

enum XAxisEnum{
    case WEEK
    case YEAR
    case DAY
    
    func getStringLabels() -> [String]{
        let calendar = Locale(identifier: "fr_FR").calendar
        switch self {
            case .WEEK:
                let symbols = calendar.veryShortWeekdaySymbols
                return Array(symbols[1..<symbols.count]) + symbols[0..<1]
            case .YEAR:
                return calendar.veryShortMonthSymbols
            case .DAY:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH"
                var hours : [String] = []
                let currentDate = Date()
                for i in (0 ... 7).reversed() {
                    let calendar = Calendar.current
                    if let date = calendar.date(byAdding: .hour, value: -i * 3, to: currentDate) {
                        hours.append("\(dateFormatter.string(from: date))H")
                    }
                }
            return hours
            
        }
    }
}
