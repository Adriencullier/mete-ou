//
//  MeteoService.swift
//  meteoApp
//
//  Created by Adrien Cullier on 26/07/2021.
//

import Foundation
import UIKit
import CoreLocation




//var latitude : Double = UserDefaults.standard.object(forKey: "latitude") as? Double ?? 0
//var longitude : Double = UserDefaults.standard.object(forKey: "longitude") as? Double ?? 0
var exclude = ""
var apiKey = "66e6437d3239ba232ac5635513d9da5c"





class MeteoService {
 
    
    
     
    
    static var shared = MeteoService()
    private init () {}
    
    private var task : URLSessionDataTask?
    
    func getMeteoUrl (lat : Double, long : Double) -> URL {
       let metoURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=\(exclude)&appid=\(apiKey)&lang=fr")!
//        print("Dans le fonction getURL, latitude:", lat, "longitude :", long)
//        print ("URL à la sortie de la fonction :", metoURL)
        return metoURL
    }
    
    func getCurrentWeather (meteoURL : URL, callback : @escaping(Bool, MeteoCurrent?)-> Void){
        let meteoURLAfterUserDefault = meteoURL
    
    var request = URLRequest(url: meteoURLAfterUserDefault)
    request.httpMethod = "GET"
    
    let session = URLSession(configuration: .default)
    task = session.dataTask(with: request) {
        (data, response, error) in
        
        DispatchQueue.main.async {
            guard let data = data, error == nil
            else {
            callback (false, nil)
            print ("Current Error1")
            return
            }
            guard let response = response as? HTTPURLResponse,  response.statusCode == 200
            else {
                callback (false, nil)
                print ("Current Error2")
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(MeteoCurrent.self, from: data)
            else {
                callback (false, nil)
                print ("Current Error3")
                return
            }
            
            callback (true, responseJSON)
            
        }
    }
    task?.resume()
}
    
    func getHourlyMeteo (meteoURL : URL, callback : @escaping(Bool, [HourlyWeather]?)-> Void){
        let meteoURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(UserDefaults.standard.object(forKey: "latitude") as? Double ?? 0)&lon=\(UserDefaults.standard.object(forKey: "longitude") as? Double ?? 0)&exclude=\(exclude)&appid=\(apiKey)&lang=fr")
        var request = URLRequest(url: meteoURL!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        task = session.dataTask(with: request) {
            (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil
                else {
                callback (false, nil)
                print ("Hourly Error1")
                return
                }
                guard let response = response as? HTTPURLResponse,  response.statusCode == 200
                else {
                    callback (false, nil)
                    print ("Hourly Error2")
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(MeteoCurrent.self, from: data)
                else {
                    callback (false, nil)
                    print ("Hourly Error3")
                    return
                }
                
                callback (true, responseJSON.hourly)
                
                let name = Notification.Name(rawValue: "hourlyForecastLoaded")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
                
            }
        }
        task?.resume()
    }
    
    func getDailyMeteo (meteoURL : URL, callback : @escaping(Bool, [DailyForecastWeather]?)-> Void){
        let meteoURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(UserDefaults.standard.object(forKey: "latitude") as? Double ?? 0)&lon=\(UserDefaults.standard.object(forKey: "longitude") as? Double ?? 0)&exclude=\(exclude)&appid=\(apiKey)&lang=fr")
        var request = URLRequest(url: meteoURL!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        task = session.dataTask(with: request) {
            (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil
                else {
                callback (false, nil)
                print ("Daily Error1")
                return
                }
                guard let response = response as? HTTPURLResponse,  response.statusCode == 200
                else {
                    callback (false, nil)
                    print ("Daily Error2")
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(MeteoCurrent.self, from: data)
                else {
                    callback (false, nil)
                    print ("Daily Error3")
                    return
                }
                
                callback (true, responseJSON.daily)
                
                let name = Notification.Name(rawValue: "dailyForecastLoaded")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
                
            }
        }
        task?.resume()
    }
    
    func getIcon (iconWeather : String) -> UIImage {
        let iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconWeather)@4x.png") ?? URL(string: "")
        let iconData = try? Data(contentsOf: (iconURL ?? URL(string: ""))!)
        let imageIcon = UIImage(data: iconData ?? Data(count: 1))!

        return imageIcon

        }
    
    func getHourFromDt (dt : Double)-> String {
        let date = Date (timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getDateFromDt (dt : Double)-> String {
        let date = Date (timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "FR-fr")
        dateFormatter.dateFormat = "EEEE"
        let dateString = dateFormatter.string(from: date)
        let dateStringCapitalized = dateString.capitalized
        
        
        return dateStringCapitalized
    }
    
    
    }
    
   


