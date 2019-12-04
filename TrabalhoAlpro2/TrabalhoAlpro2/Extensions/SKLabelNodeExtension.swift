//
//  SKLabelNodeExtension.swift
//  TrabalhoAlpro2
//
//  Created by Marcus Vinicius Vieira Badiale on 04/12/19.
//  Copyright © 2019 Marcus Vinicius Vieira Badiale. All rights reserved.
//

//
//  SKLabelNodeExtension.swift
//  TowerDefense
//
//  Created by Arthur Bastos Fanck on 09/10/19.
//

import SpriteKit

extension SKLabelNode {
    
    func adjustFontSizeForScreenSize(maxFontSize: CGFloat) {
        
        let screenWidth = UIScreen.main.bounds.width
        let downscalingPercentage: CGFloat = 0.125
        
        switch screenWidth {
        
        /* Large Screens:
             - 896: XR, 11, XS Max and 11 Pro Max
             - 812: X, XS and 11 Pro
             - 736: 6+, 6s+, 7+ and 8+ */
        case 896, 812, 736:
            self.fontSize = maxFontSize
        
        // Medium Screens: 6, 6s, 7 and 8
        case 667:
            self.fontSize = maxFontSize - (maxFontSize * downscalingPercentage)
        
        // Small Screens: 5, 5s, 5c and SE
        case 568:
            self.fontSize = maxFontSize - (maxFontSize * (downscalingPercentage * 2))
        
        // Default is equal to medium
        default:
            self.fontSize = maxFontSize - (maxFontSize * downscalingPercentage)
        }
    }
}

