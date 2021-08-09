//
//  MapViewController.swift
//  Pokedex
//
//  Created by Isaac Olmedo on 08/08/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewProtocol {

    var presenter: MapPresenterProtocol?
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var fetchPokemonButton: UIButton!
    
    let manager = CLLocationManager()
    
    var lastMyLocation = CLLocationCoordinate2D()
    var sumDistance = 0.0
    var lastPokemon = Pokemon(name: "", image: URL.init(string: "www.google.com")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        map.delegate = self
        map.showsUserLocation = true
    }

    func show(pokemon: Pokemon) {
        lastPokemon = pokemon
        let pokemonAnnotation = PokemonPointAnnotation(pokemon: pokemon)
        pokemonAnnotation.title = pokemon.name
        pokemonAnnotation.coordinate = lastMyLocation
        DispatchQueue.main.async {
            self.map.addAnnotation(pokemonAnnotation)
        }
    }
    
    @IBAction func fetchLocation(_ sender: Any) {
        let span = MKCoordinateSpan(latitudeDelta: 0.00775, longitudeDelta: 0.00775)
        let myLocation = CLLocationCoordinate2DMake(lastMyLocation.latitude, lastMyLocation.longitude)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
    }
    @IBAction func fetchPokemon(_ sender: Any) {
        presenter?.getRandomPokemon()
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
                sumDistance = 0
                lastMyLocation = myLocation
            }
        }
    }
    
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6)

        let rbearing = bearing * Double.pi / 180.0

        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
        let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
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
