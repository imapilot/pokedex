//
//  PokemonDetailVC.swift
//  pokedex-by-me
//
//  Created by Neville Smythe on 14/02/2016.
//  Copyright © 2016 Neville Smythe. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var namedLbl: UILabel!

    var pokemon: Pokemon!

    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        namedLbl.text = pokemon.name
        
        // Do any additional setup after loading the view.
        
    }
    
}
