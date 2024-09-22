//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 19.07.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    static func show() {
        ProgressHUD.colorBackground = .ypBackground
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorAnimation = .ypBlack
        ProgressHUD.colorHUD = .ypWhiteAlpha50
        ProgressHUD.mediaSize = 51
        ProgressHUD.marginSize = 10
        ProgressHUD.animate(nil, interaction: false)
    }
    
    static func dismiss() {
        ProgressHUD.dismiss()
    }
}
