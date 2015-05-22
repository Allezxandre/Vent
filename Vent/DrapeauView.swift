//
//  DrapeauView.swift
//  Vent
//
//  Created by Alexandre Jouandin on 2015/05/22.
//  Copyright (c) 2015 dodo-mac. All rights reserved.
//

import UIKit

class DrapeauView: UIView {
    
    var orientation: CGFloat = 90
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        Drapeau.drawVentometre(angle: orientation)
    }


}
