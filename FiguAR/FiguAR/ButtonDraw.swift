//  Created by Edoardo de Cal on 10/17/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import Foundation
import UIKit

class ButtonDraw: UIButton {
    
    let imageDrawView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "drawing")
        let tintableImage = image.withRenderingMode(.alwaysTemplate)
        imageView.image = tintableImage
        imageView.tintColor = .white
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        widthAnchor.constraint(equalToConstant: 80).isActive = true
        layer.cornerRadius = self.frame.height/2
        addImageDrawView()
    }
    
    func addImageDrawView() {
        addSubview(imageDrawView)
        imageDrawView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageDrawView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
