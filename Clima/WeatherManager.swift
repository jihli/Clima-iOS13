//
//  WeatherManager.swift
//  Clima
//
//  Created by JIHAO LI on 2/1/26.
//  Copyright © 2026 App Brewery. All rights reserved.
//

import Foundation
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=xxx&units=metric"
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString:String){
        //1.Create a url
        if let url = URL(string:urlString){
            // 2. Create a URLSession
            let session = URLSession(configuration:.default)
    
            // 3. Give Session a task
            let task = session.dataTask(with: url, completionHandler: handle(data:  response:  error: ))
            //创建一个任务去拉取 URL内容，请求结束后调用你提供的 completionHandler 回调，把 Data/Response/Error 传给你。
            //所以这里的input其实是系统在得到url的内容以后 解析成为了data/response/error 返回给你的 你接受了以后在handle中处理逻辑
            
            //4. Start the task
            task.resume()
        }
    }
    
    func handle(data:Data?, response:URLResponse?,error:Error?){
        // data 是具体的返回值 jason返回天气的具体参数和内容
        // response包含status和header -> status就是200 / 404之类的
        // error是只有在返回失败的时候 才会出现
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data{
            let dataString = String(data:safeData, encoding:.utf8)
            print(dataString)
        }
    }
}
