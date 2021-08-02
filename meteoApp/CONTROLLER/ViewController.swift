//
//  ViewController.swift
//  meteoApp
//
//  Created by Adrien Cullier on 26/07/2021.
//

import UIKit
import CoreLocation





class ViewController: UIViewController {

    var forcastHourlyArray = [HourlyWeather]()
    var forcastDailyArray = [DailyForecastWeather]()
    
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        iconImage.image = UIImage(named: "")
//        cityNameLabel.text = ""
//        temperatureLabel.text = ""
//        viewDidLoad()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        print ("latitude au début de viewdidload : ",UserDefaults.standard.object(forKey: "latitude"))
        
        forecastCollectionView.backgroundColor = UIColor.clear
        forecastTableView.backgroundColor = UIColor.clear
        
        let latitude = UserDefaults.standard.object(forKey: "latitude") as? Double ?? 0
        let longitude = UserDefaults.standard.object(forKey: "longitude") as? Double ?? 0
       
        
        let address = UserDefaults.standard.object(forKey: "cityName")
        self.cityNameLabel.text = "\(address ?? "Ville inconnue")"
        

    
        
        MeteoService.shared.getHourlyMeteo(meteoURL: MeteoService.shared.getMeteoUrl(lat: latitude, long: longitude))  { success, hourlyMeteo in
            if success, let hourlyMeteo = hourlyMeteo {
                self.forcastHourlyArray = [HourlyWeather]()
                for x in 0...24 {
                    
                    self.forcastHourlyArray.append(hourlyMeteo[x])
                    }
                    
                }
                
            }
        
        
        let name = Notification.Name(rawValue: "hourlyForecastLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(hourlyForecastLoaded), name: name, object: nil)
        
        
        MeteoService.shared.getDailyMeteo(meteoURL: MeteoService.shared.getMeteoUrl(lat: latitude, long: longitude)) { success, dailyMeteo in
            if success, let dailyMeteo = dailyMeteo {
                self.forcastDailyArray = [DailyForecastWeather]()
                for x in 1...dailyMeteo.count-1 {
                    
                    self.forcastDailyArray.append(dailyMeteo[x])
                    }
                    
                }
                
            }
        
        
        let name2 = Notification.Name(rawValue: "dailyForecastLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(dailyForecastLoaded), name: name2, object: nil)
        
        
        
        MeteoService.shared.getCurrentWeather (meteoURL: MeteoService.shared.getMeteoUrl(lat: latitude, long: longitude)) { success, currentWeather in
            
            if success == true {
                self.temperatureLabel.text = "\(String(describing: currentWeather?.current.celsiusTemp ?? 0))°C"
                self.iconImage.image = MeteoService.shared.getIcon(iconWeather: currentWeather?.current.weather[0].icon ?? "")
//                self.iconImage.sizeToFit()
                
                if currentWeather?.current.weather[0].main == "Clouds" {
//                    self.backgroundImage.image = UIImage(named: "clouds")
                    self.backgroundImage.image = UIImage(named: "blue")
                    self.backgroundImage.sizeToFit()
                }
                else{
                    self.backgroundImage.image = UIImage(named: "blue")
                    self.backgroundImage.sizeToFit()
                }
                
                
               
                
            }
            
        }
        let name3 = Notification.Name(rawValue: "savedUserDefault")
        NotificationCenter.default.addObserver(self, selector: #selector(savedUserDefault), name: name3, object: nil)
        
        
        
    }
    
    
    
    @IBAction func backToViewController(segue : UIStoryboardSegue) {
        
    }
    
    @objc func hourlyForecastLoaded(){
        forecastCollectionView.reloadData()
    }
    @objc func dailyForecastLoaded(){
        forecastTableView.reloadData()
    }
    @objc func savedUserDefault(){
        viewDidLoad()
    }


}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.forcastHourlyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = forecastCollectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as? ForecastCollectionViewCell
        
       
        if indexPath.item == 0 {
            cell?.hourForecastLabel.text = "Maint."
        }
        else{
            cell?.hourForecastLabel.text = "\(MeteoService.shared.getHourFromDt(dt: self.forcastHourlyArray[indexPath.item].dt))h"
        }
        cell?.iconImageView.image = MeteoService.shared.getIcon(iconWeather: self.forcastHourlyArray[indexPath.item].weather[0].icon)
        cell?.tempForecastLabel.text = "\(self.forcastHourlyArray[indexPath.item].celsiusTemp )°C"
        
        let probabilityOfRain = Int((self.forcastHourlyArray[indexPath.item].pop)*100)
        if probabilityOfRain >= 30 {
        cell?.humidityLabel.text = "\(probabilityOfRain)%"
        }
        else{
            cell?.humidityLabel.text = ""
        }
        
        cell?.backgroundColor = UIColor.clear
        
        return cell!
        
    }
    
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        forcastDailyArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "dailyForecastCell") as? DailyForecastTableViewCell
        
        cell?.dateLabel.text = MeteoService.shared.getDateFromDt(dt: forcastDailyArray[indexPath.row].dt)
        cell?.iconImage.image = MeteoService.shared.getIcon(iconWeather: forcastDailyArray[indexPath.row].weather[0].icon)
        cell?.tempLabel.text = "\(forcastDailyArray[indexPath.row].celsiusTempDay.description)°C"
        let probabilityOfRain = Int((forcastDailyArray[indexPath.row].pop)*100)
        if probabilityOfRain >= 30 {
        cell?.popLabel.text = "\(probabilityOfRain)%"
        }
        else {
            cell?.popLabel.text = ""
        }
        
        
        return cell!
    }
    
    
}

extension ViewController : UITableViewDelegate{
    
}

