//
//  MovieCollectionViewController.swift
//  BoxOffice
//
//  Created by MZ01-KYONGH on 2022/05/02.
//

import UIKit

class MovieCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var id: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "movieCollectCell"
    var movies: [Movie] = []
    
    
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    let flowLayout = UICollectionViewFlowLayout()
    let cellSize = UIScreen.main.bounds.width / 2.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        initFlowLayout()
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
                    self.collectionView.reloadData()
                }
            } catch(let err) {
                print(err.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
    
    private func initFlowLayout() {
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumLineSpacing = 2
        
        flowLayout.itemSize = CGSize(width: cellSize - 8, height: cellSize * 2)
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? MovieCollectionViewCell else {
            print("Failed to get a cell")
            return UICollectionViewCell()
        }
        
        let movie = self.movies[indexPath.row]
        
        cell.titleLabel.text = movie.title
        cell.reservationLabel.text = "\(movie.rservationGrade)위(\(movie.userRating)) / \(movie.reservationRate)"
        cell.dateLabel.text = movie.dateText
        
        switch movie.grade {
        case 0:
            cell.gradeImageView.image = UIImage(named: "ic_allages")
        case 12:
            cell.gradeImageView.image = UIImage(named: "ic_12")
        case 15:
            cell.gradeImageView.image = UIImage(named: "ic_15")
        case 19:
            cell.gradeImageView.image = UIImage(named: "ic_19")
        default:
            break
        }

        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let imageURL = URL(string: movie.thumb) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                if let index = collectionView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.imageView?.image = UIImage(data: imageData)
                        cell.imageView?.setNeedsDisplay()
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.id = self.movies[indexPath.row].id
        performSegue(withIdentifier: "collectionToMovie", sender: nil)
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
