//
//  MapViewController.swift
//  SchoolEvents
//
//  Created by acontass on 23/01/2018.
//  Copyright © 2018 acontass. All rights reserved.
//

import MapKit

/// Map view to display the location of an event.

class MapViewController: UIViewController {
    
    /// The map view.

    @IBOutlet var map: MKMapView!
    
    /// The address of the event.
    
    public var address: String!
    
    /// The title of the event and map annotation.
    
    public var titleStr: String!
    
    /// Called before the view appears, used to unhide the navigation bar.
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /// Initialization function, used to convert the address to a location and update map region.

    override func viewDidLoad() {
        super.viewDidLoad()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                return
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = self.titleStr
            self.map.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.map.setRegion(region, animated: true)
        }
    }

}
