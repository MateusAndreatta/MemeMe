//
//  GridViewCell.swift
//  MemeMe
//
//  Created by Mateus Andreatta on 24/03/24.
//

import Foundation
import UIKit

class GridViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func constraintUI() {
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }
    
    public func setup(with meme: Meme) {
        constraintUI()
        imageView.image = meme.memedImage
    }
    
}
