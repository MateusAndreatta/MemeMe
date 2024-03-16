//
//  ViewController.swift
//  MemeMe
//
//  Created by Mateus Andreatta on 11/03/24.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomTollbar: UIToolbar!
    
    private var shouldChangeViewPosition = false
    
    private let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setupTexts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    private func setupTexts() {
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        topText.delegate = self
        bottomText.delegate = self
        topText.tag = 1
        bottomText.tag = 2
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if shouldChangeViewPosition {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if shouldChangeViewPosition {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func albumButtonTap(_ sender: Any) {
        showPickerController(for: .photoLibrary)
    }
    
    
    @IBAction func cameraButtonTap(_ sender: Any) {
        showPickerController(for: .camera)
    }
    
    private func showPickerController(for type: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTap(_ sender: Any) {
        let meme = save()
        let ac = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    private func save() -> Meme {
        return Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    private func generateMemedImage() -> UIImage {
        
        shouldShowToolbar(false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        shouldShowToolbar(true)
        return memedImage
    }
    
    private func shouldShowToolbar(_ show: Bool) {
        topToolbar.isHidden = !show
        bottomTollbar.isHidden = !show
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
        }
        dismiss(animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            shouldChangeViewPosition = true
        }
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !textField.hasText {
            if textField.tag == 1 {
                textField.text = "TOP"
            }
            if textField.tag == 2 {
                textField.text = "BOTTOM"
            }
        }
        shouldChangeViewPosition = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
