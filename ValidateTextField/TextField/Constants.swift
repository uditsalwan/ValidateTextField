//
//  Constants.swift
//  ValidateTextField
//
//  Created by Udit on 28/06/19.
//  Copyright © 2019 uDemo. All rights reserved.
//

import UIKit

public struct ColorConstants {
    public static let textFieldTextColor = getUIColor(r: 155.0, g: 155.0, b: 155.0)
    public static let errorColor = getUIColor(r: 255.0, g: 0, b: 0)
    public static let darkGray = getUIColor(r: 51.0, g: 51.0, b: 51.0)
    public static let lightGray = getUIColor(r: 81.0, g: 81.0, b: 81.0)
    public static let lightGrayText = getUIColor(r: 227.0, g: 227.0, b: 227.0)
    public static let titleTextGrayColor = getUIColor(r: 139.0, g: 139.0, b: 139.0)
    
    static func getUIColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
