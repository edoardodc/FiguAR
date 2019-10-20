//  Created by Edoardo de Cal on 10/17/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import UIKit

class CustomBottom: UIButton {
    
    
    var color: UIColor?
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? self.color?.darker(by: 10) : color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        color = backgroundColor
    }
    
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = 10
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel?.font = UIFont(name: "ProximaNovaSoftW03-Regular", size: 20)
        backgroundColor = .black
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
