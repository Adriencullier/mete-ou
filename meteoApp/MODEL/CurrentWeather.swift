//
//  CurrentWeather.swift
//  meteoApp
//
//  Created by Adrien Cullier on 26/07/2021.
//

import Foundation

struct MeteoCurrent : Decodable{
    var current : CurrentWeather
    var hourly : [HourlyWeather]
    var daily : [DailyForecastWeather]
}

struct CurrentWeather : Decodable {
    var dt : Double
    var humidity : Int
    var temp : Double
    var clouds : Int
    var wind_speed : Double
    var weather : [Weather]
    var celsiusTemp : Int {
       Int(temp - 273.15)
    }
}

struct HourlyWeather : Decodable {
    var dt : Double
    var humidity : Int
    var temp : Double
    var clouds : Int
    var wind_speed : Double
    var weather : [Weather]
    var pop : Double
    var celsiusTemp : Int {
       Int(temp - 273.15)
    }
}
struct DailyForecastWeather : Decodable {
    var dt : Double
    var humidity : Int
    var temp : TempDay
    var clouds : Int
    var wind_speed : Double
    var weather : [Weather]
    var pop : Double
    var celsiusTempDay : Int {
        Int(temp.day - 273.15)
    }
    
}

struct TempDay : Decodable {
    var day : Double
}



struct Weather : Decodable {
    var id : Int
    var main : String
    var description : String
    var icon : String
}
