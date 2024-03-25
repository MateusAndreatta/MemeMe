//
//  ShowMemeViewController.swift
//  MemeMe
//
//  Created by Mateus Andreatta on 24/03/24.
//

import Foundation
import UIKit

class ShowMemeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    public var meme: Meme? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme?.memedImage
    }
    
    public func setup(with meme: Meme) {
        self.meme = meme
    }
        
}
