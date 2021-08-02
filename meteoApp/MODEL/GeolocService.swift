//
//  GeolocService.swift
//  meteoApp
//
//  Created by Adrien Cullier on 26/07/2021.
//

import Foundation
import CoreLocation

func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
    CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
  
}

func getCityFromAdress(address: String, completion: @escaping(_ cityName: CLPlacemark?, _ error: Error?) -> () ) {
    CLGeocoder().geocodeAddressString(address) { completion($0?[0], $1) }
}





func getCityFromCoordinates(location: CLLocation, completion: @escaping(_ adress: String, _ error: Error?) -> () ) {
    
    CLGeocoder().reverseGeocodeLocation(location) {completion($0![0].locality!, $1)}
    
    
//    CLGeocoder().reverseGeocodeLocation(location) { locations, error in
//        if error == nil {
//            print ("MAIS NOOOOON ??? \(locations![0].locality!.description as Any)")
//        } }
    
    
    
}










