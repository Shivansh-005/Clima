//
//  receivedInfo.swift
//  Clima
//
//  Created by Shivansh on 18/03/20.
//

import Foundation
struct receivedInfo:Decodable
{
    let name:String
    let main:Main
    let weather:[Weather]
}
struct Main:Decodable{
     let temp:Float
    let pressure:Int
}
struct Weather:Decodable{
    let id:Int
}
