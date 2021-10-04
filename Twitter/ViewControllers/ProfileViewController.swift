//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Micaella Morales on 3/1/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var joinedDateLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var segmentedControlView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userTableView: UITableView!
    
    let responder = SegmentedControlResponder()
    
    var timeline: String!
    var tweetArray = [Tweet]()
    var numberOfTweets = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userTableView.dataSource = self
        userTableView.delegate = self
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        bannerImageView.af.setImage(withURL: User.currUser.bannerImageUrl)
        profileImageView.af.setImage(withURL: User.currUser.profileImageUrl)
        nameLabel.text = User.currUser.name
        usernameLabel.text = "@" + User.currUser.username
        joinedDateLabel.text = "Joined " + getFormattedDate(format: "MMMM yyyy")
        followingCountLabel.text = String(User.currUser.followingCount)
        followersCountLabel.text = String(User.currUser.followersCount)
        
        customizeSegmentedControl()
        
        loadTweets()
    }
    
    func customizeSegmentedControl() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: segmentedControlView.frame.size.height + 1, width: segmentedControlView.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        segmentedControlView.layer.addSublayer(bottomBorder)
        
        let font = UIFont(name: "Helvetica Neue", size: 16)!
        let themeColor = UIColor(red: 45/255.0, green: 155/255.0, blue: 235/255.0, alpha: 1.0)
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: themeColor], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        segmentedControlView.addSubview(segmentedControl)

        let buttonBar = UIView()
        buttonBar.backgroundColor = themeColor
        segmentedControlView.addSubview(buttonBar)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true

        responder.setButtonBar(buttonBar: buttonBar)
        segmentedControl.addTarget(responder, action: #selector(responder.segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
    }
    
    func getFormattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"

        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = format

        let date = dateFormatter.date(from: User.currUser.joinedAt)!
        return newDateFormatter.string(from: date)
    }
    
    @objc func loadTweets() {
        if segmentedControl.selectedSegmentIndex == 0 {
            timeline = Timeline.user
        } else {
            timeline = Timeline.favorites
        }
        let parameters = ["user_id": User.currUser.id!,"count": numberOfTweets]
        Tweet.loadTweets(timeline: timeline, parameters: parameters) { (tweets) in
            self.tweetArray = tweets
            self.userTableView.reloadData()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        
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
