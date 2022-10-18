//
//  MovieCollectionCell.swift
//  MovieProject
//
//  Created by Pranjal Verma on 18/10/22.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(img: UIImage) {
        DispatchQueue.main.async {
            self.imgView.image = img
        }
    }

}
