//
//  CityService.swift
//  meteoApp
//
//  Created by Adrien Cullier on 28/07/2021.
//

import Foundation
import CoreData

class City : NSManagedObject {
    static var all : [City] {
        let request : NSFetchRequest<City> = City.fetchRequest()
        guard let cities = try? AppDelegate.viewContext.fetch(request)
        else {
            print ("le fetch n'a pas réussi")
            return []
        }
        return cities
    }
}

func saveCity (cityName : String, latitude : Double, longitude : Double){
    
    
    if City.all.contains(where: {$0.cityName == cityName}) == false {
        let city = City(context: AppDelegate.viewContext)
        city.cityName = cityName
        city.cityLatitude = latitude
        city.cityLongitude = longitude
    try? AppDelegate.viewContext.save()
    print("La ville \(cityName) a bien été enregistrée")
    }
    else{
    print("La ville \(cityName) existe déjà !")
    }
}

func deleteCity (_ city : City){
    AppDelegate.viewContext.delete(city)
    try? AppDelegate.viewContext.save()
    print("\(city) a bien été supprimée de la base de donnée")
}

func deleteAll (){
    for element in City.all {
        AppDelegate.viewContext.delete(element)
    }
    try? AppDelegate.viewContext.save()
}




