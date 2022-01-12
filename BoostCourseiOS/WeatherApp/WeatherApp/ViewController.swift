//
//  ViewController.swift
//  WeatherApp
//
//  Created by MZ01-KYONGH on 2022/01/11.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "countryCell"
    
    var countries: [Country] = []
    var countryAssetName: String?
    var countryKoreanName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.topItem?.title = "세계 날씨"
        
        decodeJson()
        tableView.reloadData()
    }
    
    private func decodeJson() {
        let jsonDecoder = JSONDecoder()
        
        guard let dataAsset = NSDataAsset(name: "countries") else {
            return
        }
        
        do {
            countries = try jsonDecoder.decode([Country].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CountryTableViewCell else {
            print("Failed to get a cell")
            return UITableViewCell()
        }
        
        let country = countries[indexPath.row]
        
        let imageName = "flag_" + country.assetName
        
        cell.countryLabel.text = country.koreanName
        cell.countryImage.image = UIImage(named: imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CountryTableViewCell else {
            print("Failed to get a cell")
            return
        }
        
        let country = countries[indexPath.row]
        
        countryAssetName = country.assetName
        countryKoreanName = country.koreanName
        
        performSegue(withIdentifier: "startToCityViewController", sender: cell)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cityViewController = segue.destination as? CityViewController else {
            return
        }
        
        cityViewController.countryAssetName = countryAssetName
        cityViewController.countryKoreanName = countryKoreanName
    }
    

}

