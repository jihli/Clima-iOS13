//
//  WeatherData.swift
//  Clima
//
//  Created by JIHAO LI on 2/19/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name:String
    let main:Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp:Double
}


struct Weather:Codable {
    let description: String
    let id:Int
}
