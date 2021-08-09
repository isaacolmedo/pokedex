//
//  MapModule.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 08/08/21.
//

import UIKit

final class MapModule {

    static func build() -> UIViewController {
        let view: MapViewController = MapViewController.loadXib()
        let interactor = MapInteractor()
        let router = MapRouter()
        let presenter = MapPresenter()

        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor

        view.presenter = presenter
        
        interactor.presenter = presenter
        
        router.view = view
        
        return view
    }
}

