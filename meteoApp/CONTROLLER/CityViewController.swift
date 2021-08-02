//
//  CityViewController.swift
//  meteoApp
//
//  Created by Adrien Cullier on 27/07/2021.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var cityTableView: UITableView!
    
   
    
    var citiesSet : Set<City> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        deleteAll()
        
        cityTableView.backgroundColor = .clear
        
        backgroundImage.image = UIImage(named: "blue")
        backgroundImage.sizeToFit()
            

    }
    
    
    
    @IBAction func okButton(_ sender: Any) {
        let cityNameTextField = cityTextField.text
        
        var cityName2 = ""
        var cityLatitude : Double  = 0
        var cityLongitude: Double = 0
        
        if cityNameTextField != "" {
            getCityFromAdress(address: cityNameTextField!) { cityName, error in
                guard let cityName = cityName, error == nil
                else {return}
                
                if cityName.locality?.description != "" {
                    cityName2 = cityName.locality!.description
                    
                }
                else {}
            
            getCoordinateFrom(address: cityName2) { coordinates, error in
                    guard let coordinates = coordinates, error == nil
                    else {
                        return
                    }
                    
                    if coordinates.latitude != 0 && coordinates.longitude != 0 {
                        
                        cityLongitude = coordinates.longitude
                        cityLatitude = coordinates.latitude
                        
                    }
                    else{}
                print ("Avant Sauveg. :", "cityname :", cityName2, "latitude :", cityLatitude, "longitude :", cityLongitude)
                saveCity(cityName: cityName2, latitude: cityLatitude, longitude: cityLongitude)
                
                self.cityTableView.reloadData()
                    
                }
                
                
                
                
                
            }
            
        }

        
        
        cityTextField.text = ""
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CityViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        City.all.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTableView.dequeueReusableCell(withIdentifier: "cityViewCell") as? CityTableViewCell
        
        cell?.cityLabel.text = City.all[indexPath.row].cityName
        
        MeteoService.shared.getCurrentWeather(meteoURL: MeteoService.shared.getMeteoUrl(lat: City.all[indexPath.row].cityLatitude, long: City.all[indexPath.row].cityLongitude)) { success, currentMeteo in
            if success, let currentMeteo = currentMeteo {
//                print(City.all[indexPath.row].cityLatitude, indexPath.row)
                cell?.iconImage.image = MeteoService.shared.getIcon(iconWeather: (currentMeteo.current.weather[0].icon))
            
                if (((currentMeteo.daily[0].pop))*100) >= 30 {
                    cell?.popLabel.text = "\(Int( ((currentMeteo.daily[0].pop))*100))%"
            }
            else {
                cell?.popLabel.text = ""
            }
                cell?.tempLabel.text = "\(currentMeteo.current.celsiusTemp)°C"
            }
            
        }
//        cell?.dateLabel.text = MeteoService.shared.getDateFromDt(dt: forcastDailyArray[indexPath.row].dt)
//        cell?.iconImage.image = MeteoService.shared.getIcon(iconWeather: forcastDailyArray[indexPath.row].weather[0].icon)
//        cell?.tempLabel.text = "\(forcastDailyArray[indexPath.row].celsiusTempDay.description)°C"
//        let probabilityOfRain = Int((forcastDailyArray[indexPath.row].pop)*100)
//        if probabilityOfRain >= 30 {
//        cell?.popLabel.text = "\(probabilityOfRain)%"
//        }
//        else {
//            cell?.popLabel.text = ""
//        }
        
        
        return cell!
    }
    
    
}

extension CityViewController : UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteCity(City.all[indexPath.row])
            cityTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let city = City.all[sourceIndexPath.row]
        cityTableView.deleteRows(at: [sourceIndexPath], with: .automatic)
        cityTableView.insertRows(at: [destinationIndexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.setValue(City.all[indexPath.row].cityName, forKey: "cityName")
        UserDefaults.standard.setValue(City.all[indexPath.row].cityLatitude, forKey: "latitude")
        UserDefaults.standard.setValue(City.all[indexPath.row].cityLongitude, forKey: "longitude")
        
        let name3 = Notification.Name(rawValue: "savedUserDefault")
        let notification = Notification(name: name3)
        NotificationCenter.default.post(notification)
    }
}
