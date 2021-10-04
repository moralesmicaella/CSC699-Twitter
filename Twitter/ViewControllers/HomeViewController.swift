//
//  HomeViewController.swift
//  Twitter
//
//  Created by Micaella Morales on 2/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var homeTableView: UITableView!
    
    var tweetArray = [Tweet]()
    var numberOfTweets = Int()
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let logoImage = UIImage(named: "TwitterLogoBlue")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        navigationItem.titleView = logoImageView
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        numberOfTweets = 10
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        homeTableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadTweets()
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        User.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loadTweets() {
        Tweet.loadTweets(timeline: Timeline.home, parameters: ["count": numberOfTweets]) { (tweets) in
            self.tweetArray = tweets
            self.homeTableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            numberOfTweets += 10
            loadTweets()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        
        let tweet = tweetArray[indexPath.row]
        cell.tweet = tweet
        
        return cell
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
