import UIKit
import MapKit

class ViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureLocationServices()
        
        let amagerCenter = CLLocation(latitude: 55.651876, longitude: 12.577519)
        let region = MKCoordinateRegionMakeWithDistance(
            amagerCenter.coordinate,
            2000, 1100)
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 8000)
        mapView.setCameraZoomRange(zoomRange, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    //OUR ANNOTATIONS
    private func addAnnotations() {
        
        //Fancy Tree - 1
        let fancyTreeAnnotation = MKPointAnnotation()
        fancyTreeAnnotation.coordinate = CLLocationCoordinate2D(latitude: 55.65290 , longitude: 12.58485)
        fancyTreeAnnotation.subtitle = "Fancy Tree"
        
        //Fancy Bench - 2
        let benchAnnotation = MKPointAnnotation()
        benchAnnotation.coordinate = CLLocationCoordinate2D(latitude: 55.65139 , longitude: 12.58350)
        benchAnnotation.subtitle = "Bench"
        
        //Tree of Life - 3
        let treeOfLifeAnnotation = MKPointAnnotation()
        treeOfLifeAnnotation.coordinate = CLLocationCoordinate2D(latitude: 55.65196 , longitude: 12.57738)
        treeOfLifeAnnotation.subtitle = "Tree of Life"
    
        //Stone Table - 4
        let stoneTableAnnotation = MKPointAnnotation()
        stoneTableAnnotation.coordinate = CLLocationCoordinate2D(latitude: 55.65074 , longitude: 12.57640)
        stoneTableAnnotation.subtitle = "Stone Table"
        
        mapView.addAnnotation(fancyTreeAnnotation)
        mapView.addAnnotation(benchAnnotation)
        mapView.addAnnotation(treeOfLifeAnnotation)
        mapView.addAnnotation(stoneTableAnnotation)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotations()
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        if let subtitle = annotation.subtitle, subtitle == "Fancy Tree" {
            annotationView?.image = UIImage(named: "PoI")
        } else if let subtitle = annotation.subtitle, subtitle == "Bench" {
            annotationView?.image = UIImage(named: "PoI")
        } else if let subtitle = annotation.subtitle, subtitle == "Tree of Life" {
            annotationView?.image = UIImage(named: "PoI")
        } else if let subtitle = annotation.subtitle, subtitle == "Stone Table" {
            annotationView?.image = UIImage(named: "PoI")
        } else if annotation === mapView.userLocation {
            annotationView?.image = UIImage(named: "myLocation")
        }
        annotationView?.canShowCallout = true
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(String(describing: view.annotation?.title))")
    }
}

