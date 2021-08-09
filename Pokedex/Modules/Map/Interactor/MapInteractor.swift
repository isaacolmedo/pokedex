//
//  MapInteractor.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 08/08/21.
//

import Foundation
import PokemonAPI
import Combine

enum MapInteractorError: Error {
    case notFound
}

final class MapInteractor: MapInteractorProtocol {
    var presenter: MapPresenterProtocol?
    private let tolaPokemons = 800
    
    func fetchRandomPokemon() {
        PokemonAPI().pokemonService.fetchPokemon(Int.random(in: 1..<tolaPokemons)) { result in
            switch result {
            case .success(let pokemon):
                debugPrint(pokemon)
                guard let name = pokemon.name, let image = pokemon.sprites?.frontDefault, let imageURL = URL(string: image) else {
                    self.presenter?.failureFetch(with: MapInteractorError.notFound)
                    return
                }
                self.presenter?.successGet(pokemon: Pokemon(name: name, image: imageURL))
            case .failure(let error):
                self.presenter?.failureFetch(with: error)
            }
        }
    }
}


