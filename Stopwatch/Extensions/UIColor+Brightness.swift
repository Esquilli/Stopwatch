//
//  UIColor+Brightness.swift
//  Stopwatch
//
//  Created by Pedro Fernandez on 12/15/21.
//

import UIKit

extension UIColor {
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }

    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            if brightness < 1.0 {
                let newB: CGFloat = max(min(brightness + (percentage/100.0)*brightness, 1.0), 0.0)
                return UIColor(hue: hue, saturation: saturation, brightness: newB, alpha: alpha)
            } else {
                let newS: CGFloat = min(max(saturation - (percentage/100.0)*saturation, 0.0), 1.0)
                return UIColor(hue: hue, saturation: newS, brightness: brightness, alpha: alpha)
            }
        }
        return self
    }
}
