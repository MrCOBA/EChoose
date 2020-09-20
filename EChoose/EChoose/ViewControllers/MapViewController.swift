//
//  MapViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 15.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var address: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        searchBar.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        //setPlacemark()
    }
    
    func setUI() {
        
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = .zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 0.5
        
        mapView.layer.cornerRadius = 20
        mapView.layer.shadowColor = UIColor.black.cgColor
        mapView.layer.shadowOffset = .zero
        mapView.layer.shadowRadius = 5
        mapView.layer.shadowOpacity = 0.5
    }
    
    @objc
    func tapHandler(_ recognizer: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    private func setPlacemark() {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [self] (placemarks, error) in
            
            if let error = error {
                print(error)
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.address
            annotation.subtitle = "Working place"
            
            guard let placemarkLocation = placemark?.location else { return }
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            annotation.coordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
}
extension MapViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        address = searchBar.text!
        
        if address != "" {
            setPlacemark()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        addressLabel.text = "Address: \(address)"
    }
}
