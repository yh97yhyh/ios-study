//
//  MovieViewController.swift
//  BoxOffice
//
//  Created by MZ01-KYONGH on 2022/05/02.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var id: String?
    
    @IBOutlet weak var commentTableView: UITableView!
    let cellIdentifier = "commentCell"
    var comments: [Comment] = []
    
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradeDurationLabel: UILabel!
    @IBOutlet weak var reservationGradeLabel: UILabel!
    @IBOutlet weak var reservationRateLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestMovie()
        requestComments()
    }
    
    private func requestMovie() {
        guard let id = id else { return }
        
        guard let url = URL(string: "https://connect-boxoffice.run.goorm.io/movie?id=\(id)") else {
            return
        }
        
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
                let movie = try JSONDecoder().decode(MovieDetail.self, from: data)
                self.initView(movie)
            } catch(let err) {
                print(err.localizedDescription)
            }

        }
        
        dataTask.resume()
    }
    
    private func requestComments() {
        guard let id = id else { return }
        
        guard let url = URL(string: "https://connect-boxoffice.run.goorm.io/comments?movie_id=\(id)") else {
            return
        }
        
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
                let apiResponse = try JSONDecoder().decode(APIResponseComments.self, from: data)
                self.comments = apiResponse.comments
                
                DispatchQueue.main.async {
                    self.commentTableView.reloadData()
                }
            } catch(let err) {
                print(err.localizedDescription)
            }

        }
        
        dataTask.resume()
    }
    
    private func initView(_ movie: MovieDetail) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let imageURL = URL(string: movie.image) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                
                switch movie.grade {
                case 0:
                    self.gradeImageView.image = UIImage(named: "ic_allages")
                case 12:
                    self.gradeImageView.image = UIImage(named: "ic_12")
                case 15:
                    self.gradeImageView.image = UIImage(named: "ic_15")
                case 19:
                    self.gradeImageView.image = UIImage(named: "ic_19")
                default:
                    break
                }
                self.navigationItem.title = movie.title
                self.titleLabel.text = movie.title
                self.dateLabel.text = "\(movie.date) 개봉"
                self.gradeDurationLabel.text = "\(movie.genre) / \(movie.duration)분"
                self.reservationGradeLabel.text = "\(movie.reservationGrade)위"
                self.reservationRateLabel.text = "\(movie.reservationRate)%"
                self.userRatingLabel.text = String(movie.userRating)
                self.audienceLabel.text = String(movie.audience)
                self.synopsisLabel.text = movie.synopsis
                self.directorLabel.text = movie.director
                self.actorLabel.text = movie.actor
                self.thumbnailView.image = UIImage(data: imageData)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commentTableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                              for: indexPath) as? CommentTableViewCell else {
            print("Failed to get a cell")
            return UITableViewCell()
        }
        
        let comment = self.comments[indexPath.row]
        
        cell.writerlabel.text = comment.writer
        cell.timestampLabel.text = comment.fullDate
        cell.contentsLabel.text = comment.contents
        cell.userImage.image = UIImage(named: "ic_user_loading")
        
        return cell
    }
    
    @IBAction func touchUpWriteButton(_ sender: Any) {
        performSegue(withIdentifier: "comment", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondVC = segue.destination as? CommentViewController else { return }
        secondVC.id = self.id
        initBackButton()
    }
    
    func initBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

}
