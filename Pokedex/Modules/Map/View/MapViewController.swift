//
//  MapViewController.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 08/08/21.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {

    var presenter: MapPresenterProtocol?
    
    // Private vars
    private let manager = CLLocationManager()
    private var lastMyLocation = CLLocationCoordinate2D()
    private var lastPokemon = Pokemon(name: "", image: URL.init(string: "www.google.com")!)
    
    @IBOutlet private weak var map: MKMapView!
    @IBOutlet private weak var fetchPokemonButton: UIButton!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        map.delegate = self
        map.showsUserLocation = true
        fetchPokemonButton.layer.cornerRadius = 10
    }
    
    @IBAction private func fetchLocation(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: 0.00775, longitudeDelta: 0.00775)
        let myLocation = CLLocationCoordinate2DMake(lastMyLocation.latitude, lastMyLocation.longitude)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
    }
    @IBAction private func fetchPokemon(_ sender: Any) {
        presenter?.getRandomPokemon()
    }
    
    @IBAction private func segmentedControlChanged(_ sender: Any) {
        presenter?.isGPS = segmentedControl.selectedSegmentIndex == 0
    }
}

extension MapViewController: MapViewProtocol {
    
    func showAlert(with error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func show(pokemon: Pokemon, with distanceToLocation: Double) {
        lastPokemon = pokemon
        let pokemonAnnotation = PokemonPointAnnotation(pokemon: pokemon)
        pokemonAnnotation.title = pokemon.name
        pokemonAnnotation.coordinate = locationWithBearing(bearingRadians: distanceToLocation, distanceMeters: distanceToLocation, origin: lastMyLocation)
        DispatchQueue.main.async {
            self.map.addAnnotation(pokemonAnnotation)
        }
    }
    
    private func locationWithBearing(bearingRadians:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6)
        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearingRadians))
        let lon2 = lon1 + atan2(sin(bearingRadians) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            if lastMyLocation.latitude == 0.0 {
                lastMyLocation = myLocation
            }
            let distance = location.distance(from: CLLocation(latitude: lastMyLocation.latitude,
                                                              longitude: lastMyLocation.longitude))
            if distance.magnitude > 100 {
                presenter?.getRandomPokemon()
                lastMyLocation = myLocation
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pokemonAnnotation = annotation as? PokemonPointAnnotation else { return nil }

        let identifier: String = annotation.title!!
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        annotationView?.applyImage(from: pokemonAnnotation.pokemon.image)
        return annotationView
    }
}
