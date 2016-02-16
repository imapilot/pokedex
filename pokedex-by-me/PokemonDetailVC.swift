//
//  PokemonDetailVC.swift
//  pokedex-by-me
//
//  Created by Neville Smythe on 14/02/2016.
//  Copyright © 2016 Neville Smythe. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum Segment: Int {
        case Bio = 0
        case Moves = 1
    }
    
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
    
    
    @IBOutlet weak var movesTbl: UITableView!
    @IBOutlet weak var segCtrl: UISegmentedControl!
    @IBOutlet weak var bioStackView: UIStackView!
    @IBOutlet weak var bioRedBarV: UIView!
    @IBOutlet weak var bioBottomEvoImg: UIStackView!
    @IBOutlet weak var bioNextEvoBtn: UIButton!

    var pokemon: Pokemon!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        movesTbl.delegate = self
        movesTbl.dataSource = self
       
        namedLbl.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        // using custom clouser to delay the assignment of values until the web request has been completed
        pokemon.downloadPokemonDetails { () -> () in
            // make sure COMPLETED() is being called in the pokemon class
            
            self.updateUI()     // Custom func in the VC model
        }
        
        movesTbl.hidden = true
        
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
            bioNextEvoBtn.hidden = true
        } else {
            bioNextEvoBtn.hidden = false
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
            evoLbl.text = str
        }
        movesTbl.reloadData()
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func nextEvoBtnPressed(sender: AnyObject) {
        
        let nextPokemon = Pokemon(name: pokemon.nextEvolutionTxt, pokedexId: Int(pokemon.nextEvolutionId)!)
        
        nextPokemon.downloadPokemonDetails { () -> () in
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let pokeDetailVC =
                storyboard.instantiateViewControllerWithIdentifier("DetailVC") as! PokemonDetailVC
            
            pokeDetailVC.pokemon = nextPokemon
            pokeDetailVC.modalTransitionStyle = .CrossDissolve

             self.presentViewController(pokeDetailVC, animated: true, completion: nil)
        }
    }

    
    @IBAction func segmentBtnPressed(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == Segment.Bio.rawValue {
            bioStackView.hidden = false
            bioRedBarV.hidden = false
            bioNextEvoBtn.hidden = false
            bioBottomEvoImg.hidden = false
            
            movesTbl.hidden = true
        } else {
            bioStackView.hidden = true
            bioRedBarV.hidden = true
            bioNextEvoBtn.hidden = true
            bioBottomEvoImg.hidden = true
            
            movesTbl.hidden = false
        }
        segCtrl.hidden = false
    }
    
    // MOVES
    func tableView(movesTbl: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = movesTbl.dequeueReusableCellWithIdentifier("MovesCell") as? MovesCell {
            
            if pokemon.moves.count  > 0 {
                cell.configureCell(pokemon.moves[indexPath.row])
            }
            return cell
            
        } else {
            return UITableViewCell()
        }

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.moves.count
    }
    
}
