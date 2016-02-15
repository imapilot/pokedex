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
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var nextEvoBtn: UIButton!

    var pokemon: Pokemon!

    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        namedLbl.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        // using custom clouser to delay the assignment of values until the web request has been completed
        pokemon.downloadPokemonDetails { () -> () in
            // make sure COMPLETED() is being called in the pokemon class
            
            self.updateUI()     // Custom func in the VC model
        }
        
        // Do any additional setup after loading the view.
        
    }
    
    // custom func only called with COMPLETED() sent in model -- see viewDidLoad
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        pokedexLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
            nextEvoBtn.hidden = true
        } else {
            nextEvoBtn.hidden = false
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
            evoLbl.text = str
        }
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func nextEvoBtnPressed(sender: AnyObject) {
        
        let nextPokemon = Pokemon(name: pokemon.nextEvolutionTxt, pokedexId: Int(pokemon.nextEvolutionId)!)
        
        nextPokemon.downloadPokemonDetails { () -> () in
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let pokeDetailVC =
                storyboard.instantiateViewControllerWithIdentifier("PokemonDetailVC") as! PokemonDetailVC
            
            pokeDetailVC.pokemon = nextPokemon
            pokeDetailVC.modalTransitionStyle = .CrossDissolve
            
            self.presentViewController(pokeDetailVC, animated: true, completion: nil)
        }
    }

    
}
