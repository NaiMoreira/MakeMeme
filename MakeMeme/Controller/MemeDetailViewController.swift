//
//  MemeDetailViewController.swift
//  MakeMeme
//
//  Created by Nai on 16.03.20.
//  Copyright © 2020 Nai. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var topText = ""
    var bottomText = ""
    var originalImg = UIImage()
    var memeImg = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = memeImg
        print(topText)
        print(bottomText)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "editMeme" {
            let destinationView = segue.destination as! ViewController
            destinationView.meme.topText = topText
            destinationView.meme.bottomText = bottomText
            destinationView.meme.originalImage = originalImg
            destinationView.meme.memedImage = memeImg
        }
    }
}
