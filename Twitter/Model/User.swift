//
//  User.swift
//  Twitter
//
//  Created by Micaella Morales on 2/25/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import Foundation

class User {
    
    static var currUser = User()
    
    var id: Int!
    var name: String!
    var username: String!
    var profileImageUrl: URL!
    var bannerImageUrl: URL!
    var followingCount: Int!
    var followersCount: Int!
    var joinedAt: String!
    
    init() {
    }
    
    init(user: NSDictionary) {
        name = user["name"] as? String
        username = user["screen_name"] as? String
        profileImageUrl = URL(string: user["profile_image_url"] as! String)!
    }
    
    static func login(success: @escaping (Bool) -> Void) {
        let loginUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: loginUrl, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            return success(true)
        }, failure: { (Error) in
            print("Error logging in: \(Error)")
        })
    }
    
    static func logout() {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    static func setCurrUser(success: @escaping (Bool) -> Void){
        let accountUrl = "https://api.twitter.com/1.1/account/verify_credentials.json"
        TwitterAPICaller.client?.getDictionaryRequest(url: accountUrl, parameters: [:], success: { (user) in
            User.currUser.id = user["id"] as? Int
            User.currUser.name = user["name"] as? String
            User.currUser.username = user["screen_name"] as? String
            User.currUser.profileImageUrl = URL(string: user["profile_image_url"] as! String)!
            User.currUser.bannerImageUrl = URL(string: user["profile_banner_url"] as! String)!
            User.currUser.followingCount = user["friends_count"] as? Int
            User.currUser.followersCount = user["followers_count"] as? Int
            User.currUser.joinedAt = user["created_at"] as? String

            return success(true)
        }, failure: { (Error) in
            print("Error getting user: \(Error)")
        })
    }
    
}
