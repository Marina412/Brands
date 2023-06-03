//
//  onboardingCollectionViewCell.swift
//  Brandy
//
//  Created by Aya Mohamed Ahmed on 01/06/2023.
//

import UIKit

class onboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var onboardingTitle: UILabel!
    @IBOutlet weak var onboardingDescription: UILabel!
    
    func setup(_ slide:onboardingSlide){
        onboardingImage.image=UIImage(named: slide.image)
        onboardingTitle.text=slide.title
        onboardingDescription.text=slide.description
    }
    
}
