//
//  MemeModel.swift
//  MakeMeme
//
//  Created by Nai on 09.03.20.
//  Copyright © 2020 Nai. All rights reserved.
//

import Foundation
import UIKit

struct Memes {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}
