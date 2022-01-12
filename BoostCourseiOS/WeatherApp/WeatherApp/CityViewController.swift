//
//  CityViewController.swift
//  WeatherApp
//
//  Created by MZ01-KYONGH on 2022/01/11.
//

import UIKit

class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "cityCell"
    
    var cities: [City] = []
    var countryAssetName: String?
    var countryKoreanName: String?
    
    var cityName: String?
    var weather: String?
    var temperature: String?
    var precipitation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.topItem?.title = "세계 날씨"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        decodeJson()
        tableView.reloadData()
    }
    
    private func decodeJson() {
        let jsonDecoder = JSONDecoder()
        
        guard let countryAssetName = countryAssetName else {
            return
        }
        
        guard let dataAsset = NSDataAsset(name: countryAssetName) else {
            return
        }
        
        do {
            cities = try jsonDecoder.decode([City].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell else {
            print("Failed to get a cell")
            return UITableViewCell()
        }
        
        let city = cities[indexPath.row]
        
        cell.cityLabel.text = city.cityName
        cell.temperature.text = city.temperature
        cell.precipitation.text = city.precipitation
        
        if city.rainfallProbability > 70 {
            weather = "rainy"
        } else if city.rainfallProbability > 40 {
            weather = "cloudy"
        } else if city.rainfallProbability > 40, city.celsius < 0 {
            weather = "snowy"
        } else {
            weather = "sunny"
        }
        
        guard let weather = weather else {
            return UITableViewCell()
        }
        
        cell.weatherImage.image = UIImage(named: weather)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell else {
            print("Failed to get a cell")
            return
        }
        
        let city = cities[indexPath.row]
        
        if city.rainfallProbability > 70 {
            weather = "rainy"
        } else if city.rainfallProbability > 40 {
            weather = "cloudy"
        } else if city.rainfallProbability > 40, city.celsius < 0 {
            weather = "snowy"
        } else {
            weather = "sunny"
        }
        
        cityName = city.cityName
        temperature = city.temperature
        precipitation = city.precipitation
        
        performSegue(withIdentifier: "startToWeatherViewController", sender: cell)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let weatherViewController = segue.destination as? WeatherViewController else {
            return
        }
        
        guard let weather = weather else {
            return
        }
        
        weatherViewController.weather = weather
        weatherViewController.cityName = cityName
        weatherViewController.temperature = temperature
        weatherViewController.precipitation = precipitation
    }

}
