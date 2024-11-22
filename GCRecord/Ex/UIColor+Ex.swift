//
//  UIColor+Ex.swift
//  GCRecord
//
//  Created by Prank on 22/11/24.
//

import UIKit

extension UIColor {
    /// Khởi tạo UIColor từ chuỗi hex
    /// - Parameter hex: Chuỗi hex (ví dụ: "E0E0E0", "#E0E0E0")
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        let length = hexSanitized.count
        guard length == 6 || length == 8 else { return nil }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red, green, blue, alpha: CGFloat
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
            alpha = 1.0
        } else {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

