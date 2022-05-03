//
//  ViewController.swift
//  Networking
//
//  Created by MZ01-KYONGH on 2022/04/28.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "friendCell"
    var friends: [Friend] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didRecieveFriendsNotification(_:)),
                                               name: DidReceiveFriendsNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestFriends()
    }
    
    @objc func didRecieveFriendsNotification(_ noti: Notification) {
        guard let friends = noti.userInfo?["friends"] as? [Friend] else { return }
        self.friends = friends
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier,
                                                                  for: indexPath)
        
        let friend = self.friends[indexPath.row]
        
        cell.textLabel?.text = friend.name.full
        cell.detailTextLabel?.text = friend.email
        cell.imageView?.image = nil
        
        DispatchQueue.global(qos: .default).async {
            guard let imageURL = URL(string: friend.picture.thumbnail) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.imageView?.image = UIImage(data: imageData)
                        cell.setNeedsDisplay()
                        cell.layoutIfNeeded()
                    }
                }
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

}

