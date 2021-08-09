//
//  MapPresenter.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 08/08/21.
//

import Foundation

class MapPresenter: MapPresenterProtocol {
    weak var view: MapViewProtocol?
    var interactor: MapInteractorProtocol?
    var router: MapRouterProtocol?
    
    func getRandomPokemon() {
        interactor?.fetchRandomPokemon()
    }
    
    func successGet(pokemon: Pokemon) {
        view?.show(pokemon: pokemon)
    }
    
    func failureFetch() {
        
    }
}
