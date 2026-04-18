//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

//UIViewController：继承苹果的页面基类，才能拥有生命周期（viewDidLoad 等）和 UI 管理能力
//UITextFieldDelegate：表示这个类要实现 文本框代理。代理用于接收文本框事件（比如按 Return、结束编辑、是否允许结束编辑等）
class WeatherViewController: UIViewController,UITextFieldDelegate,WeatherManagerDelegate {
    // @IBOutlet：告诉 Xcode 这个属性可以在 Interface Builder（storyboard）里连线。不同的元素已经和这里的代码建立联系了
    //weak：弱引用，避免循环引用导致内存泄漏
    //var xxx: 类型!：UIImageView / UILabel / UITextField：控件类型。
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    //super.viewDidLoad()：先让父类做它必须做的初始化
    //searchTextField.delegate = self: 把 searchTextField 的代理设置为当前控制器,这样下面这些代理方法才会被触发：textFieldShouldReturn + textFieldShouldEndEditing + textFieldDidEndEditing
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    // _ sender这里的"_"表示在调用函数的时候 不用强制写出Name = xxx, 直接输入xxx就可以
    //searchTextField.endEditing(true) -> 会接下来调用textFieldShouldEndEditing + textFieldDidEndEditing
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    // textFieldShouldReturn处理的是user在当前唯一的一个UITextField界面中
    // 输入return以后 做的事情 这里会首先print(searchTextField.text!)
    // 然后调用textFieldShouldEndEditing + textFieldDidEndEditing 把搜索框的字变成""
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    // textFieldShouldEndEditing会对应不应该把搜索框字清零进行判断
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // textFieldDidEndEditing对搜索框的内容 变成""
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use searchTextField.text to get the weather for that city
        
        // 如下if是尝试解包 如果不为空 才执行{}中
        // 也就是weatherManager.fetchWeather(cityName:city)的内容
        // 这个时候用户输入的text 以后会调用fetchWeather的逻辑(现在是把整体的url打印出来)
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName:city)
        }
        
        //最后把用户的输入框归零
        searchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel){
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName:weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}



//Note of 04182026
// MARK: - 整体执行流程总结
//
// 一次完整搜索的大致流程如下：
//
// 1. 页面加载
//    -> viewDidLoad()
//    -> 设置两个代理：
//       searchTextField.delegate = self
//       weatherManager.delegate = self
//
// 2. 用户输入城市名
//    -> 比如输入 "Beijing"
//
// 3. 用户触发搜索
//    有两种方式：
//    A. 点击按钮 -> searchPressed(_ sender: UIButton)
//    B. 点击键盘 Return -> textFieldShouldReturn(_ textField: UITextField)
//
// 4. 两种方式最后都会执行：
//    searchTextField.endEditing(true)
//
// 5. 结束编辑前先检查：
//    -> textFieldShouldEndEditing(_ textField: UITextField)
//    - 如果输入为空：return false，不继续
//    - 如果输入不为空：return true，继续
//
// 6. 结束编辑后执行：
//    -> textFieldDidEndEditing(_ textField: UITextField)
//    - 取出输入内容
//    - 调用 weatherManager.fetchWeather(cityName: city)
//    - 清空输入框
//
// 7. WeatherManager 发起网络请求
//    - 请求天气 API
//    - 解析返回数据
//
// 8. 请求成功时：
//    -> didUpdateWeather(_:weather:)
//    - 当前代码里打印 temperature
//    - 实际上应该在这里更新页面 UI
//
// 9. 请求失败时：
//    -> didFailWithError(error:)
//    - 打印错误信息

