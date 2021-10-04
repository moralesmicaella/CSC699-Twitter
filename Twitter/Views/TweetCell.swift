//
//  TweetCell.swift
//  Twitter
//
//  Created by Micaella Morales on 2/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    
    @IBOutlet weak var profileImgTopConstraintWithRetweet: NSLayoutConstraint!
    @IBOutlet weak var profileImgTopConstraint: NSLayoutConstraint!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user.name
            usernameLabel.text = "@" + tweet.user.username
            profileImageView.af.setImage(withURL: tweet.user.profileImageUrl)
            tweetContentLabel.text = tweet.content
            retweetCountLabel.text = displayCount(count: tweet.retweetCount)
            favoriteCountLabel.text = displayCount(count: tweet.favoriteCount)
            setRetweetIcon(isRetweeted: tweet.isRetweeted)
            setFavoriteIcon(isFavorited: tweet.isFavorited)
            timeLabel.text = getRelativeTime(timeString: tweet.createdAt)
            
            if tweet.isRetweeted && tweet.timeline == Timeline.user {
                profileImgTopConstraint.isActive = false
                profileImgTopConstraintWithRetweet.isActive = true
                retweetIcon.alpha = 1.0
                retweetedLabel.alpha = 1.0
            } else {
                profileImgTopConstraintWithRetweet.isActive = false
                profileImgTopConstraint.isActive = true
                retweetIcon.alpha = 0
                retweetedLabel.alpha = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 0.25
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onRetweetButton(_ sender: Any) {
        if tweet.isRetweeted {
            tweet.unretweet(tweetId: tweet.id) { (success) in
                if success {
                    self.setRetweetIcon(isRetweeted: false)
                }
            }
        } else {
            tweet.retweet(tweetId: tweet.id) { (success) in
                if success {
                    self.setRetweetIcon(isRetweeted: true)
                }
            }
        }
        
        tweet.updateRetweetCount(tweetId: tweet.id) { (success) in
            self.retweetCountLabel.text = self.displayCount(count: self.tweet.retweetCount)
        }
    }
    
    @IBAction func onFavoriteButton(_ sender: Any) {
        if tweet.isFavorited {
            tweet.unfaveTweet(tweetId: tweet.id) { (success) in
                if success {
                    self.setFavoriteIcon(isFavorited: false)
                }
            }
        } else {
            tweet.faveTweet(tweetId: tweet.id) { (success) in
                if success {
                    self.setFavoriteIcon(isFavorited: true)
                }
            }
        }
        
        tweet.updateFavoriteCount(tweetId: tweet.id) { (success) in
            self.favoriteCountLabel.text = self.displayCount(count: self.tweet.favoriteCount)
        }
        
    }
    
    func setRetweetIcon(isRetweeted: Bool) {
        let retweetIcon = isRetweeted ? UIImage(named: "retweet-icon-green") : UIImage(named: "retweet-icon")
        retweetButton.setImage(retweetIcon, for: .normal)
        
    }
    
    func setFavoriteIcon(isFavorited: Bool) {
        let favoriteIcon = isFavorited ? UIImage(named: "favor-icon-red") : UIImage(named: "favor-icon")
        favoriteButton.setImage(favoriteIcon, for: .normal)
    }
    
    func displayCount(count: Int) -> String {
        let thousands = 1000
        let tenThousands = 10000
        let hundredThousands = 100000
        let millions = 1000000
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if count == 0 {
            return ""
        } else if count > 0 && count < tenThousands {
            return numberFormatter.string(from: NSNumber(value: count)) ?? String(count)
        } else if count < hundredThousands {
            return String(format: "%.1fK", Double(count) / Double(thousands))
        } else if count < millions {
            return String(format: "%dK", count / thousands)
        } else {
            return String(format: "%.1fM", Double(count) / Double(millions))
        }
    }
    
    func getRelativeTime(timeString: String) -> String {
        let now = Date()
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        
        let secondsAgo = Int(now.timeIntervalSince(time))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return String(format: "· %ds", secondsAgo)
        } else if secondsAgo < hour {
            return String(format: "· %dm", secondsAgo / minute)
        } else if secondsAgo < day {
            return String(format: "· %dh", secondsAgo / hour)
        } else if secondsAgo < week {
            return String(format: "· %dd", secondsAgo / day)
        } else {
            return String(format: "· %dw", secondsAgo / week)
        }
    }

}
