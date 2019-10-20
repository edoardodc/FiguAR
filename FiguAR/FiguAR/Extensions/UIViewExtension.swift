//  Created by Edoardo de Cal on 10/17/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func bounce(damping: CGFloat, option: AnimationOptions) {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0.3,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: 8,
                       options: option,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: nil)
    }
    
}

