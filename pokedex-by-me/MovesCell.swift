//
//  MovesCell.swift
//  pokedex-by-me
//
//  Created by Neville Smythe on 15/02/2016.
//  Copyright © 2016 Neville Smythe. All rights reserved.
//

import UIKit

class MovesCell: UITableViewCell {

    @IBOutlet weak var mainLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 5.0
        mainLbl.layer.cornerRadius = 20.0
        mainLbl.clipsToBounds = true
    }

    func configureCell(text: String) {
        mainLbl.text = text
    }

}
