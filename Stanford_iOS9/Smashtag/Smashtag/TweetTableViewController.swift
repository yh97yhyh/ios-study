//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by MZ01-KYONGH on 2021/11/24.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController {
    
    private var tweets = [Array<Tweet>]() {
        didSet {
            print(tweets)
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    private func twitterRequest() -> Twitter.TwitterRequest? {
        if let query = searchText, !query.isEmpty {
            return Twitter.TwitterRequest(search: query, count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.TwitterRequest?
    private func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                if request == self?.lastTwitterRequest {
                    self?.tweets.insert(newTweets, at: 0)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText = "#stanford"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

}
