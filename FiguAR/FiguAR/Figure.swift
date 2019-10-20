//  Created by Edoardo de Cal on 10/16/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import Foundation
import UIKit

class Figure {
    
    var name: String
    var imageTexture: UIImage?
    var numBlocks: Int
    var nameFile: String = ""
    
    init(name: String, imageTexture: UIImage?, numBlocks: Int, nameFile: String) {
        self.name = name
        self.imageTexture = imageTexture
        self.numBlocks = numBlocks
        self.nameFile = nameFile
    }
    
}
