//
//  HourlyMeteo.swift
//  meteoApp
//
//  Created by Adrien Cullier on 26/07/2021.
//

import Foundation

// Hourly forecast for 48 hours

struct HourlyMeteo : Decodable {
    var hourly : [MeteoCurrent]
}
