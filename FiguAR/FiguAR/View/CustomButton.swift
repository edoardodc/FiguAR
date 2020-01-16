//  Created by Edoardo de Cal on 10/17/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = 10
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        backgroundColor = .black
        titleLabel?.font = UIFont(name: "ProximaNovaSoftW03-Bold.ttf", size: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
