//
//  ViewController.swift
//  WeatherApp
//
//  Created by Александр Мехович on 12/9/19.
//  Copyright © 2019 AlexMex. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humindityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        fetchCurrentWeatherData()
    }
    
    func toggleActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    
    lazy var weatherManager = APIWeatherManager(apiKey: "0ecce4de5191db804a735816d7fd411c")
    var coordinates = Coordinates(latitude: 53.928231, longitude: 27.475031)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        
        
        fetchCurrentWeatherData()
        
        print("my location latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
    }
    
    func fetchCurrentWeatherData() {
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            
            self.toggleActivityIndicator(on: false)
            switch result {
            case .Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                
                let alertController = UIAlertController(title: "Unable to get data", message: "\(error.localizedDescription) ", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated:  true, completion: nil)
            default: break
            }
        }
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.appearentTemperatureLabel.text = currentWeather.appearentTemperatureString
        self.humindityLabel.text = currentWeather.humidityString
    }
}


