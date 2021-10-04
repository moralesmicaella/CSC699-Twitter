//
//  Tweet.swift
//  Twitter
//
//  Created by Micaella Morales on 2/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import Foundation

class Tweet {
    
    var user: User
    var id: Int
    var content: String
    var favoriteCount: Int
    var retweetCount: Int
    var isFavorited: Bool
    var isRetweeted: Bool
    var createdAt: String
    var timeline: String
    
    init(dict: NSDictionary) {
        var tweet: NSDictionary
        if let retweetStatus = dict["retweeted_status"] as? NSDictionary {
            tweet = retweetStatus
        } else {
            tweet = dict
        }
        user = User(user: tweet["user"] as! NSDictionary)
        id = tweet["id"] as! Int
        content = tweet["text"] as! String
        retweetCount = tweet["retweet_count"] as! Int
        favoriteCount = tweet["favorite_count"] as! Int
        isRetweeted = tweet["retweeted"] as! Bool
        isFavorited = tweet["favorited"] as! Bool
        createdAt = tweet["created_at"] as! String
        timeline = ""
    }
    
    static func loadTweets(timeline: String, parameters: [String: Any], success: @escaping ([Tweet]) -> Void) {
        var tweetArray = [Tweet]()
        TwitterAPICaller.client?.getDictionariesRequest(url: Timeline.timelineUrls[timeline]!, parameters: parameters, success: { (tweetDictionaries: [NSDictionary]) in
            for dictionary in tweetDictionaries {
                let tweet = Tweet.init(dict: dictionary)
                tweet.timeline = timeline
                tweetArray.append(tweet)
            }
            return success(tweetArray)
        }, failure: { (Error) in
            print("Error retrieving tweets: \(Error)")
        })
    }
    
    static func postTweet(status: String, success: @escaping (Bool) -> Void) {
        let statusUrl = "https://api.twitter.com/1.1/statuses/update.json"
        let myParameters = ["status": status] as [String: Any]
        TwitterAPICaller.client?.postRequest(url: statusUrl, parameters: myParameters, success: {
                return success(true)
        }, failure: { (Error) in
            print("Error posting tweet: \(Error)")
        })
    }
    
    func getStatus(tweetId: Int, success: @escaping (NSDictionary) -> Void) {
        let statusUrl = "https://api.twitter.com/1.1/statuses/show.json"
        let myParameters = ["id": tweetId]
        TwitterAPICaller.client?.getDictionaryRequest(url: statusUrl, parameters: myParameters, success: { (tweet) in
            return success(tweet)
        }, failure: { (Error) in
            print("Error getting tweet: \(Error)")
        })
    }
    
    func retweet(tweetId: Int, success: @escaping (Bool) -> Void) {
        let retweetUrl = "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
        let myParameters = ["id": tweetId]
        TwitterAPICaller.client?.postRequest(url: retweetUrl, parameters: myParameters, success: {
            return success(true)
        }, failure: { (Error) in
            print("Error retweeting: \(Error)")
        })
    }
    
    func unretweet(tweetId: Int, success: @escaping (Bool) -> Void) {
        let unretweetUrl = "https://api.twitter.com/1.1/statuses/unretweet/\(tweetId).json"
        let myParameters = ["id": tweetId]
        TwitterAPICaller.client?.postRequest(url: unretweetUrl, parameters: myParameters, success: {
            return success(true)
        }, failure: { (Error) in
            print("Error unretweeting: \(Error)")
        })
    }
    
    func faveTweet(tweetId: Int, success: @escaping (Bool) -> Void) {
        let favoriteUrl = "https://api.twitter.com/1.1/favorites/create.json"
        let myParameters = ["id": tweetId]
        TwitterAPICaller.client?.postRequest(url: favoriteUrl, parameters: myParameters, success: {
            return success(true)
        }, failure: { (Error) in
            print("Error favoriting tweet: \(Error)")
        })
    }
    
    func unfaveTweet(tweetId: Int, success: @escaping (Bool) -> Void) {
        let unfavoriteUrl = "https://api.twitter.com/1.1/favorites/destroy.json"
        let myParameters = ["id": tweetId]
        TwitterAPICaller.client?.postRequest(url: unfavoriteUrl, parameters: myParameters, success: {
            return success(true)
        }, failure: { (Error) in
            print("Error unfavoriting tweet: \(Error)")
        })
    }
    
    func updateRetweetCount(tweetId: Int, success: @escaping (Bool) -> Void) {
        getStatus(tweetId: tweetId) { (tweet) in
            self.retweetCount = tweet["retweet_count"] as! Int
            return success(true)
        }
    }
    
    func updateFavoriteCount(tweetId: Int, success: @escaping (Bool) -> Void) {
        getStatus(tweetId: tweetId) { (tweet) in
            self.favoriteCount = tweet["favorite_count"] as! Int
            return success(true)
        }
    }
    
    func setTimeline(timeline: String) {
        self.timeline = timeline
    }
    
    
}
