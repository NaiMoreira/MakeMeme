//
//  ViewController.swift
//  MakeMeme
//
//  Created by Nai on 09.03.20.
//  Copyright © 2020 Nai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    let textFieldDelegate = TextFieldDelegate()
    var font = UIFont()

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var meme = Memes(topText: "TOP", bottomText: "BOTTOM", originalImage: UIImage(), memedImage: UIImage())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.text = meme.topText
        bottomTextField.text = meme.bottomText
        imageView.image = meme.originalImage
        
        topTextField.delegate = textFieldDelegate
        bottomTextField.delegate = textFieldDelegate
        
        topTextField.defaultTextAttributes = textFieldDelegate.textFieldatributtes
        bottomTextField.defaultTextAttributes = textFieldDelegate.textFieldatributtes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if imageView.image == nil {
            activityButton.isEnabled = false
        }
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - Actions (image, share, cancel)
    
    @IBAction func cameraPickImage(_ sender: UIBarButtonItem) {
        let cameraPickerController = UIImagePickerController()
        cameraPickerController.delegate = self
        cameraPickerController.sourceType = .camera
        present(cameraPickerController, animated: true, completion: nil)
    }
    
    @IBAction func albumPickImage(_ sender: UIBarButtonItem) {
        let albumPickerController = UIImagePickerController()
        albumPickerController.delegate = self
        albumPickerController.sourceType = .photoLibrary
        present(albumPickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtomPressed(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities:   nil)
        present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(error != nil){
                print(error as Any)
            } else if !success {
                self.dismiss(animated: true, completion: nil)
            }  else {
                self.SaveMeme(memeImg: memedImage)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func cancelButtomPreseed(_ sender: UIBarButtonItem) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        activityButton.isEnabled = false
        topTextField.defaultTextAttributes = textFieldDelegate.textFieldatributtes
        bottomTextField.defaultTextAttributes = textFieldDelegate.textFieldatributtes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changeFontPressed(_ sender: UIBarButtonItem) {
        let fontPicker = UIFontPickerViewController()
        fontPicker.delegate = self
        present(fontPicker, animated: true, completion: nil)
        
    }
    
    //MARK: - Save Meme
    
    func SaveMeme(memeImg: UIImage) {
        if let topText = topTextField.text, let bottomText = bottomTextField.text, let originalImage = imageView.image {
            meme.topText = topText
            meme.bottomText = bottomText
            meme.originalImage = originalImage
            meme.memedImage = memeImg
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        navBar.isHidden = true
        toolBar.isHidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolBar.isHidden = false

        return memedImage
    }
    
    //MARK: - Watching Keyboard
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if textFieldDelegate.activeField == 1 {

            guard let userInfo = notification.userInfo else {return}
            guard let keyBoardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
            let keyBoardFrame = keyBoardSize.cgRectValue
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyBoardFrame.height
            }
        }

    }

    @objc func keyboardWillHide(_ notification:Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        textFieldDelegate.activeField = 0
    }

    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

//MARK: - UIImapickerController extension

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: enableActivityButton )
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func enableActivityButton() {
        activityButton.isEnabled = true
    }
}

//MARK: - UIFontPicker extension

extension ViewController: UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        font = UIFont(descriptor: descriptor, size: 40)
        topTextField.defaultTextAttributes.updateValue(font, forKey: .font)
        bottomTextField.defaultTextAttributes.updateValue(font, forKey: NSAttributedString.Key.font)
    }
}
