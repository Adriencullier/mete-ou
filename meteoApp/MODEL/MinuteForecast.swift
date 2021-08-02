//
//  MinuteForecast.swift
//  meteoApp
//
//  Created by Adrien Cullier on 26/07/2021.
//

import Foundation

// Minute forecast for 1 hour


struct MinuteForecast {
    
    var minutly : [Minutly]
}

struct Minutly {
    var dt : Int
    var precipitation : Int
}
