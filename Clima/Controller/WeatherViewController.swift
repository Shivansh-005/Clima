//
//  ViewController.swift
//  Clima
//


import UIKit
import CoreLocation
var city:String?
var weatherManager=WeatherManager()
class WeatherViewController: UIViewController{
    var locationManager:CLLocationManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.delegate=self
        weatherManager.delegate=self
        locationManager=CLLocationManager()
        locationManager?.delegate=self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager?.requestLocation()
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let pos=locations.last!
            weatherManager.fetchdata(City: "&lat=\(pos.coordinate.latitude)&lon=\(pos.coordinate.longitude)")
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if textBox.text != ""{
            city=textBox.text
            textBox.endEditing(true)
        }
    }
}
//MARK: - UITextFieldDelegate
extension WeatherViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textBox.text != ""{
            city=textBox.text
            textBox.endEditing(true)
            return true
        }
        else
        {return false}
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textBox.text=""
        weatherManager.fetchdata(City:city!)
    }
    
}
//MARK: - WeatherManagerField
extension WeatherViewController:WeatherManagerField{
    func didUpdateWeather(passed: ReturnInfo) {
        DispatchQueue.main.async {
            print(passed.temp)
            self.cityLabel.text=passed.name
            self.conditionImageView.image=UIImage(systemName: passed.conditionImage)
            self.temperatureLabel.text=String(format: "%.01f", passed.temp)
        }
    }
}
//MARK: - didUpdateLocation
extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pos=locations.last!
        weatherManager.fetchdata(City: "&lat=\(pos.coordinate.latitude)&lon=\(pos.coordinate.longitude)")
          locationManager?.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
