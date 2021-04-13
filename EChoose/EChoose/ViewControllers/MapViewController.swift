//
//  MapViewController.swift
//  EChoose
//
//  Created by Oparin Oleg on 15.09.2020.
//  Copyright © 2020 Oparin Oleg. All rights reserved.
//

import UIKit
import MapKit

protocol MapControllerDelegate {
    
    func add(_ locationDefault: LocationDefault)
    func replace(_ locationDefault: LocationDefault, _ index: Int)
    func reload()
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameTextField: CustomTextField!
    
    var editingLocation: LocationDefault?
    var locationDefault: LocationDefault?
    var globalManager: GlobalManager = GlobalManager.shared
    var locationsManager: LocationsManager = LocationsManager.shared
    var editorMode: EditorMode = .new
    var address: String = ""
    var delegate: MapControllerDelegate?
    
    private var coordinate: CLLocationCoordinate2D?
    private var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        searchBar.delegate = self
        nameTextField.delegate = self
        
        self.overrideUserInterfaceStyle = .light
        
        if editorMode == .edit {
            
            guard let editingLocation = editingLocation else {
                return
            }
            locationDefault = locationsManager.copy(of: editingLocation)
            
            searchBar.text = locationDefault?.toString()
            addressLabel.text = locationDefault?.toString()
            nameTextField.text = locationDefault?.name
            address = locationDefault?.toString() ?? ""
            setPlacemark()
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.view.addGestureRecognizer(tapGestureRecognizer)
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
    
    @IBAction func addAddress(_ sender: Any) {
        
        guard let locationDefault = locationDefault else {
            return
        }
        
        locationDefault.name = nameTextField.text ?? "No Location Name"
        
        if editorMode == .new {
            locationsManager.addLocation(locationDefault, completition: {[unowned self] in
                locationsManager.loadData(completition: {
                    DispatchQueue.main.async {[unowned self] in
                        delegate?.reload()
                        dismiss(animated: true, completion: nil)
                    }
                })
            })
            
        } else {
            
            guard let id = locationDefault.id, let index = locationsManager.id2index(id) else {
                return
            }
            locationsManager.replaceLocation(locationDefault, with: index, completition: {[unowned self] in
                locationsManager.loadData(completition: {
                    DispatchQueue.main.async {[unowned self] in
                        delegate?.reload()
                        dismiss(animated: true, completion: nil)
                    }
                })
            })
        }
        
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
            annotation.subtitle = nameTextField.text == "" ? "No Name" : nameTextField.text
            
            guard let placemarkLocation = placemark?.location else { return }
            self.location = placemarkLocation
            self.coordinate = placemarkLocation.coordinate
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            annotation.coordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func geoDecoder() {
        
        guard let location = location else {
            return
        }
        guard let coordinate = coordinate else {
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {[unowned self] placemarks, error -> Void in
            
            // Place details
            guard let placeMark = placemarks?.first else { return }
            if editorMode == .new {
                locationDefault = LocationDefault(coordinate.latitude, coordinate.longitude)
            } else {
                locationDefault?.latitude = coordinate.latitude
                locationDefault?.longitude = coordinate.longitude
            }
            
            // Location name
            if let locationName = placeMark.location {
                print(locationName)
            }
            // Street address
            if let street = placeMark.thoroughfare {
                locationDefault?.street = street
            }
            // House number... i.e.
            if let additionalStreetInfo = placeMark.subThoroughfare {
                locationDefault?.additionalStreetInfo = additionalStreetInfo
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                locationDefault?.city = city
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                locationDefault?.zipcode = zip
            }
            // Country
            if let country = placeMark.country {
                locationDefault?.country = country
            }
            
            addressLabel.text = "Address: \(locationDefault?.toString() ?? "")"
        })
    }
}
extension MapViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        address = searchBar.text!
        
        if address != "" {
            setPlacemark()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        geoDecoder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        geoDecoder()
    }
}
extension MapViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        setPlacemark()
    }
}
