//
//  MapPresenter.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 08/08/21.
//

import Foundation

final class MapPresenter: MapPresenterProtocol {
    weak var view: MapViewProtocol?
    var interactor: MapInteractorProtocol?
    var router: MapRouterProtocol?
    
    var timer: Timer?
    var isGPS = true {
        didSet {
            guard !isGPS else {
                timer?.invalidate()
                return
            }
            timer = Timer.scheduledTimer(timeInterval: secondsToRepeat, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
    }
    
    let secondsToRepeat = 30.0
    
    func getRandomPokemon() {
        interactor?.fetchRandomPokemon()
    }
    
    func successGet(pokemon: Pokemon) {
        var distance = 0.0
        if !isGPS {
            distance = Double.random(in: 0..<2000)
        }
        view?.show(pokemon: pokemon, with: distance)
    }
    
    func failureFetch(with error: Error) {
        view?.showAlert(with: error)
    }
    
    @objc func fireTimer() {
        getRandomPokemon()
    }
}
