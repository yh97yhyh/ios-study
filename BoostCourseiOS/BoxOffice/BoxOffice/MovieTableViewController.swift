//
//  ViewController.swift
//  BoxOffice
//
//  Created by MZ01-KYONGH on 2022/04/28.
//

import UIKit

class MovieTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var id: String?

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "movieCell"
    var movies: [Movie] = []
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestMovies(orderType)
    }
    
    private func requestMovies(_ orderType: OrderType) {
        guard let url = URL(string: "https://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType.rawValue)") else { return }
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }

            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.movies = apiResponse.movies
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch(let err) {
                print(err.localizedDescription)
            }
        }
        
        dataTask.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? MovieTableViewCell else {
            print("Failed to get a cell")
            return UITableViewCell()
        }
        
        let movie = self.movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.detailLabel.text = movie.detail
        cell.dateLabel.text = movie.dateText
        
        switch movie.grade {
        case 0:
            cell.gradeImage.image = UIImage(named: "ic_allages")
        case 12:
            cell.gradeImage.image = UIImage(named: "ic_12")
        case 15:
            cell.gradeImage.image = UIImage(named: "ic_15")
        case 19:
            cell.gradeImage.image = UIImage(named: "ic_19")
        default:
            break
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let imageURL = URL(string: movie.thumb) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                if let index = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.imageView?.image = UIImage(data: imageData)
                        cell.imageView?.setNeedsDisplay()
                    }
                }
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.id = self.movies[indexPath.row].id
        performSegue(withIdentifier: "tableToMovie", sender: nil)
    }
    
    @IBAction func touchUpSettingButton(_ sender: Any) {
        showAlertController()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondVC = segue.destination as? MovieViewController else { return }
        secondVC.id = self.id
        initBackButton()
    }
    
    func initBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "영화목록", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func showAlertController() {
        let handler: (UIAlertAction) -> Void
        handler = { (action: UIAlertAction) in
            let type = action.title
            
            switch type {
            case "예매율":
                orderType = .type0
            case "큐레이션":
                orderType = .type1
            case "개봉일":
                orderType = .type2
            default:
                break
            }
            self.requestMovies(orderType)
        }
        
        let alertController = UIAlertController(title: "정렬방식 선택",
                                                message: "영화를 어떤 순서로 정렬할까요?",
                                                preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        
        let type0Action = UIAlertAction(title: "예매율",
                                        style: .default,
                                        handler: handler)
        
        let type1Action = UIAlertAction(title: "큐레이션",
                                        style: .default,
                                        handler: handler)
        
        let type2Action = UIAlertAction(title: "개봉일",
                                        style: .default,
                                        handler: handler)
        
        alertController.addAction(cancelAction)
        alertController.addAction(type0Action)
        alertController.addAction(type1Action)
        alertController.addAction(type2Action)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

