//
//  MemeCollectionViewController.swift
//  MakeMeme
//
//  Created by Nai on 16.03.20.
//  Copyright © 2020 Nai. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    var memes: [Memes]! {
        let object = UIApplication.shared.delegate
        let appdelegate = object as! AppDelegate
        return appdelegate.memes
    }
    var indexPath = IndexPath()
    var longPressedEnabled = false
    var isAnimate = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        longPressedEnabled = false
        doneBtn.isEnabled = false
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addMeme", sender: self)
        
    }

    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! MemeCollectionViewCell
        let memeImage = memes[indexPath.row]
        cell.memeImage.image = memeImage.memedImage
        
        if longPressedEnabled   {
            cell.startAnimate()
        }else{
            cell.stopAnimate()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        performSegue(withIdentifier: "collectionMemeDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionMemeDetail" {
            let destinationView = segue.destination as! MemeDetailViewController
            let destMeme = memes[indexPath.row]
            destinationView.topText = destMeme.topText
            destinationView.bottomText = destMeme.bottomText
            destinationView.originalImg = destMeme.originalImage
            destinationView.memeImg = destMeme.memedImage
        }
    }
    
    //MARK: - Configure Long Press
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                return
            }
            self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            self.collectionView.endInteractiveMovement()
            doneBtn.isEnabled = true
            longPressedEnabled = true
            self.self.collectionView.reloadData()
        default:
            self.collectionView.cancelInteractiveMovement()
        }
    }

    @IBAction func removeBtnClick(_ sender: UIButton) {
        let hitPoint = sender.convert(CGPoint.zero, to: self.collectionView)
        let hitIndex = self.collectionView.indexPathForItem(at: hitPoint)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.remove(at: (hitIndex?.row)!)
        self.collectionView.reloadData()
        }
    
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        doneBtn.isEnabled = false
        longPressedEnabled = false
        self.collectionView.reloadData()
    }
    
}
