//
//  ViewController.swift
//  MemeMe02
//
//  Created by nouf alharbi on 1/26/19.
//  Copyright © 2019 nouf alharbi. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    //Variables
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    var memedImage: UIImage!
    var editMeme: Meme!
    
    var barsVisible = false
    
    
    
    let memeTextAttributes: [String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black, /* TODO: fill in appropriate UIColor */
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -6]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let meme = editMeme {
            configureViews(top: meme.topText, bottom: meme.bottomText, image: meme.originalImage, share: true)
        } else {
            configureViews(top: "TOP", bottom: "BOTTOM", image: nil, share: false)
        }
    }
    
    func configureViews(top: String, bottom: String, image: UIImage?, share: Bool){
        configureTextFields(textField: self.topField, string: top)
        configureTextFields(textField: self.bottomField, string: bottom)
        self.shareButton.isEnabled = share
        if let unwrappedImage = image {
            imageView.image = unwrappedImage
        }
    }
    
    func configureTextFields(textField: UITextField, string: String) {
        textField.text = string
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotificaiton()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        toggleNavAndTabBars(on: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toggleNavAndTabBars(on: false)
        unsubscribeFromKeyboardNotification()
    }
    
    func toggleNavAndTabBars(on: Bool) {
        self.tabBarController?.tabBar.isHidden = on
        self.navigationController?.navigationBar.isHidden = on
    }
   
    @IBAction func album(_ sender: Any) {
         presentImagePickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func camera(_ sender: Any) {
         presentImagePickerController(sourceType: .camera)
    }
    

    
    func presentImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // Setup subscription to keybord events(show/hide)
    func subscribeToKeyboardNotificaiton(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // unsubscribe from keyboard events
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // offset view by the height of the keyboard
    @objc func keyboardWillShow(_ notification: Notification) {
        
        // check if view has already been repositioned
        // check if top textfield is currently being edited
        if view.frame.origin.y == 0 && !self.topField.isEditing {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    // return the position of the view to normal
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Perform Screen capture
    func generateMemedImage() -> UIImage {
        
        toggleBars(on: self.barsVisible)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toggleBars(on: self.barsVisible)
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        if checkMemeParameters() {
            let meme = Meme(topText: topField.text!, bottomText: bottomField.text!, originalImage: imageView.image!, memedImage: memedImage)
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
        }
    }
    
    func checkMemeParameters() -> Bool {
        
        if (topField.text) == nil {
            return false
        }
        
        if (bottomField.text) == nil {
            return false
        }
        
        if (imageView.image) == nil {
            return false
        }
        
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // toggle visibility nav and toolbar
    func toggleBars(on: Bool) {
        self.barsVisible = !on
        self.toolBar.isHidden = !on
        self.navBar.isHidden = !on
    }
    
    @IBAction func share(_ sender: Any) {
        if (self.imageView.image) != nil {
            
            memedImage = generateMemedImage()
            let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
            
            activityController.completionWithItemsHandler = { activityController, success, items, error in
                
                if !success {
                    return
                }
                
                self.save(memedImage: self.memedImage)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
 
    @IBAction func cancel(_ sender: Any) {
         self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension CreateMemeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
}

extension CreateMemeViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage  {
            self.imageView.image = image
            self.imageView.contentMode = UIViewContentMode.scaleAspectFit
            self.shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

    
   
