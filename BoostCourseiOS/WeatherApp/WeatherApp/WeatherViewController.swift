//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by MZ01-KYONGH on 2022/01/12.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    var cityName: String?
    var weather: String?
    var temperature: String?
    var precipitation: String?
    
    var weatherText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.navigationController?.navigationBar.topItem?.title = cityName
        initWeatherInfo()
    }
    
    private func initWeatherInfo() {
        switch weather {
        case "rainy":
            weatherText = "비"
        case "cloudy":
            weatherText = "흐림"
        case "snoy":
            weatherText = "눈"
        case "sunny":
            weatherText = "맑음"
        default:
            weatherText = ""
        }
        
        guard let weather = weather else {
            return
        }
        
        weatherImage.image = UIImage(named: weather)
        weatherLabel.text = weatherText
        temperatureLabel.text = temperature
        precipitationLabel.text = precipitation
  
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
