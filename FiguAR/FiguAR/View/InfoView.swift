//  Created by Edoardo de Cal on 10/17/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import UIKit

class InfoView: UIVisualEffectView {
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "ProximaNovaSoftW03-Regular", size: 18)
        label.text = "👇 Tocca uno dei tre bottoni per creare una figura!"
        label.textColor = .white
        return label
    }()
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: UIBlurEffect(style: .dark))
        setup()
    }
    
    func setup() {
        layer.cornerRadius = 11
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: 420).isActive = true
        addLabel()
    }
    
    func addLabel() {
        self.contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
