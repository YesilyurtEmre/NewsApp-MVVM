//
//  CategoryCell.swift
//  NewsApp-MVVM
//
//  Created by Emre Yeşilyurt on 9.10.2024.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var categoryCellView: UIView!
    @IBOutlet weak var categoryCellLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(with category: Categories, isSelected: Bool) {
        if isSelected {
            categoryCellView.backgroundColor = .white
            categoryCellLbl.textColor = .black
        } else {
            categoryCellView.backgroundColor = UIColor.categoryCellViewColor
            categoryCellLbl.textColor = UIColor.categoryCellLabelColor
        }
        categoryCellLbl.text = category.title
        categoryCellLbl.lineBreakMode = .byWordWrapping
    }
    
}
