//
//  MapProtocols.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 08/08/21.
//

import Foundation
import MapKit

protocol MapRouterProtocol: AnyObject {
    
}

protocol MapPresenterProtocol: AnyObject {
    func getRandomPokemon()
    func successGet(pokemon: Pokemon)
    func failureFetch()
}

protocol MapInteractorProtocol: AnyObject {
    func fetchRandomPokemon()
}

protocol MapViewProtocol: AnyObject {
    func show(pokemon: Pokemon)
}

struct Pokemon {
    let name: String
    let image: URL
}

class PokemonPointAnnotation: MKPointAnnotation {
    let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
