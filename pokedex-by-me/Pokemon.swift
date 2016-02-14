//
//  Pokemon.swift
//  pokedex-by-me
//
//  Created by Neville Smythe on 13/02/2016.
//  Copyright © 2016 Neville Smythe. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var name: String {
        get {
            return _name
        }
    }
    var pokedexId: Int {
        get {
            return _pokedexId
        }
    }
    var description: String {
        get {
            if _description == nil {
               _description = ""
            }
            return _description
        }
    }
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }
    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
            return _height
        }
    }
    var weight: String {
        get {
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
    }
    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }
    var nextEvolutionTxt: String {
        get {
            if _nextEvolutionTxt == nil {
                _nextEvolutionTxt = ""
            }
            return _nextEvolutionTxt
        }
    }
    var nextEvolutionId: String {
        get {
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    }
    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }


    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete){
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String,AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }

                
                self._type = ""
                if let types = dict["types"] as? [Dictionary<String,AnyObject>] where types.count > 0 {
                    
                    if let name = types[0]["name"] as? String {
                        self._type! += name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] as? String {
                                self._type! += " / \(name.capitalizedString)"
                            }
                        }
                    }
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String,AnyObject>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] as? String {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON{ response in
                            if let descDict = response.result.value as? Dictionary<String,AnyObject> {
                                if let description = descDict["description"] as? String{
                                    self._description = description.stringByReplacingOccurrencesOfString("POKMON", withString: "pokemon")
                                    //print(description)
                                }
                            }
                            
                            completed() // custom clouser -- needs the completed() to be called for it to work, otherwise in pokemonDetailVc the pokemon.downloadPokemonDetails will not fire..
                        }
                    }
                } else {
                    self._description = ""
                }
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.isEmpty != true {
                    
                    if let to = evolutions[0]["to"] as? String {
                        // not supporting mega pokemon from api
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                //print(self._nextEvolutionId)
                                //print(self._nextEvolutionTxt)
                                //print(self._nextEvolutionLvl)
                            }
                        }
                    }
                }
                //print(self._weight)
                //print(self._height)
                //print(self._defense)
                //print(self._attack)
                //print(self._type)
                
            }
        
        }
        
    }
}