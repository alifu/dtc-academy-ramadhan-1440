//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alif Docotel on 20/05/19.
//  Copyright © 2019 AppWork. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imgWeather: UIImageView!
    @IBOutlet var locationWeather: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var infoWeather: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var position: String = "-5.162705,119.437436"
    var darkSkyKey: String = "Key dari Dark Sky"
    var darkSkyLink: String = "https://api.darksky.net/forecast"
    var darkSkyIcon: String = "https://darksky.net/images/weather-icons/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.aturView(status: true)
        self.ambilData()
    }
    
    func aturView(status: Bool) {
        self.imgWeather.isHidden = status
        self.locationWeather.isHidden = status
        self.temperature.isHidden = status
        self.infoWeather.isHidden = status
        self.loadingIndicator.isHidden = !status
    }
    
    func ambilData() {
        let urlRequest = "\(self.darkSkyLink)/\(self.darkSkyKey)/\(self.position)"
        let url = URL(string: urlRequest)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                print("Connection Failed")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                DispatchQueue.main.async {
                    self.prosesHasil(json: json)
                }
            } catch {
                print("Request Error")
            }
        }
        task.resume()
    }

    func prosesHasil(json: Any) {
        if let weather = json as? [String: Any] {
            let locationGet = weather["timezone"] as! String
            if let currently = weather["currently"] as? [String: Any] {
                let temperatureGet = currently["temperature"] as! Double
                let infoGet = currently["summary"] as! String
                let iconGet = currently["icon"] as! String
                self.temperature.text = "\(temperatureGet)º F"
                self.infoWeather.text = infoGet
                self.ambilIcon(icon: iconGet)
            }
            self.locationWeather.text = locationGet
        }
        self.aturView(status: false)
    }
    
    func ambilIcon(icon: String) {
        do {
            let urlImage = URL(string: "\(self.darkSkyIcon)\(icon).png")
            let dataImage = try Data(contentsOf: urlImage!)
            DispatchQueue.main.async {
                self.imgWeather.image = UIImage(data: dataImage)
            }
        } catch {
            print("Download Failed")
        }
    }

}

