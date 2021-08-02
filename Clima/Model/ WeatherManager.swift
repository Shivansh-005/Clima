//
//  File.swift
//  Clima
//
//  Created by Shivansh on 17/03/20.
//

import Foundation
protocol WeatherManagerField {
    func didUpdateWeather(passed:ReturnInfo)
}
var address:String?
var resultcity=""
struct WeatherManager {
    var delegate:WeatherManagerField?
    func fetchdata(City:String)
    {
        address="https://api.openweathermap.org/data/2.5/weather?q=\(City)&appid=676cbb6d6f366e1596299b2258d860e3&units=metric"
        address=address!.replacingOccurrences(of: " ", with: "+")
        
        getLiveData()
       //print(resultcity)
    }
    func getLiveData()
    {
        let url=URL(string: address!)!
        let session=URLSession(configuration: .default)
        let task=session.dataTask(with: url, completionHandler:handler(data:response:error:))

        task.resume()
    }
    func handler(data:Data?,response:URLResponse?,error:Error?)
    {
        //print("Inside handler")
        if error != nil
        {
            print(error!)
            return
        }
        if let safeData=data
        {
            let passed=parseData(weatherData: safeData)
            delegate?.didUpdateWeather(passed:passed)
        }
    }
    func parseData(weatherData:Data)->ReturnInfo
    {
       var returnInfo = ReturnInfo(name: "City Not Found!", id: 301, conditionImage:"xmark.seal", temp: 0)
        let decoder=JSONDecoder()
        do{
            let decodedData=try (decoder.decode(receivedInfo.self, from: weatherData))
            let name=decodedData.name
           //
            //print(name)
        
            let temp=decodedData.main.temp
           // print(temp)
            let pressure=decodedData.main.pressure
            let id=decodedData.weather[0].id
            var conditionImage:String{ switch id {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
             }
            }
             returnInfo=ReturnInfo(name: name, id: id, conditionImage: conditionImage, temp: temp)
           return returnInfo
        }
        catch
         {
                print(error)
            return returnInfo
        }
    }
}
