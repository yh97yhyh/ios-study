//
//  CommentViewController.swift
//  BoxOffice
//
//  Created by MZ01-KYONGH on 2022/05/03.
//

import UIKit

class CommentViewController: UIViewController {
    
    var id: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var writerTextField: UITextField!
    @IBOutlet weak var contentsTextField: UITextField!
    @IBOutlet weak var completeButton: UIBarButtonItem!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "한줄평 작성"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestMovie()
    }
    
    private func initView(_ movie: MovieDetail) {
        DispatchQueue.main.async {
//            self.ratingSlider.alpha = 0.02
            self.ratingLabel.text = "0"
            self.titleLabel.text = movie.title
            
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
            
            self.starImageView1.image = UIImage(named: "ic_star_large")
            self.starImageView2.image = UIImage(named: "ic_star_large")
            self.starImageView3.image = UIImage(named: "ic_star_large")
            self.starImageView4.image = UIImage(named: "ic_star_large")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        }
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
    
    private func postComment(movieId: String, rating: Double, writer: String, contents: String) {
        let comment = PostComment(rating: rating, writer: writer, movieId: movieId, contents: contents)
        
        guard let url = URL(string: "https://connect-boxoffice.run.goorm.io/comment") else {
            return
        }
        guard let uploadData = try? JSONEncoder().encode(comment) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        task.resume()
    }
    
    @IBAction func changedRatingValue(_ sender: UISlider) {
        let ratingValue = Int(sender.value)
        self.ratingLabel.text = String(ratingValue)
        
        switch ratingValue {
        case 0:
            self.starImageView1.image = UIImage(named: "ic_star_large")
            self.starImageView2.image = UIImage(named: "ic_star_large")
            self.starImageView3.image = UIImage(named: "ic_star_large")
            self.starImageView4.image = UIImage(named: "ic_star_large")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 1:
            self.starImageView1.image = UIImage(named: "ic_star_large_half")
            self.starImageView2.image = UIImage(named: "ic_star_large")
            self.starImageView3.image = UIImage(named: "ic_star_large")
            self.starImageView4.image = UIImage(named: "ic_star_large")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 2:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large")
            self.starImageView3.image = UIImage(named: "ic_star_large")
            self.starImageView4.image = UIImage(named: "ic_star_large")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 3:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large_half")
            self.starImageView3.image = UIImage(named: "ic_star_large")
            self.starImageView4.image = UIImage(named: "ic_star_large")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 4:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large_full")
            self.starImageView3.image = UIImage(named: "ic_star_large")
            self.starImageView4.image = UIImage(named: "ic_star_large")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 5:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large_full")
            self.starImageView3.image = UIImage(named: "ic_star_large_half")
            self.starImageView4.image = UIImage(named: "ic_star_large")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 6:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large_full")
            self.starImageView3.image = UIImage(named: "ic_star_large_full")
            self.starImageView4.image = UIImage(named: "ic_star_large")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 7:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large_full")
            self.starImageView3.image = UIImage(named: "ic_star_large_full")
            self.starImageView4.image = UIImage(named: "ic_star_large_half")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 8:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large_full")
            self.starImageView3.image = UIImage(named: "ic_star_large_full")
            self.starImageView4.image = UIImage(named: "ic_star_large_full")
            self.starImageView5.image = UIImage(named: "ic_star_large")
        case 9:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large_full")
            self.starImageView3.image = UIImage(named: "ic_star_large_full")
            self.starImageView4.image = UIImage(named: "ic_star_large_full")
            self.starImageView5.image = UIImage(named: "ic_star_large_half")
        case 10:
            self.starImageView1.image = UIImage(named: "ic_star_large_full")
            self.starImageView2.image = UIImage(named: "ic_star_large_full")
            self.starImageView3.image = UIImage(named: "ic_star_large_full")
            self.starImageView4.image = UIImage(named: "ic_star_large_full")
            self.starImageView5.image = UIImage(named: "ic_star_large_full")
        default:
            break
        }
        
    }
    
    @IBAction func touchUpCompleteButton(_ sender: Any) {
        guard let id = id else { return }
        let rating = Double(Int(self.ratingSlider.value))
        guard let writer = self.writerTextField.text else { return }
        guard let contents = self.contentsTextField.text else { return }

        postComment(movieId: id, rating: rating, writer: writer, contents: contents)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
