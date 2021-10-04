//
//  Timeline.swift
//  Twitter
//
//  Created by Micaella Morales on 3/3/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import Foundation

struct Timeline {
    static let home = "home"
    static let user = "user"
    static let favorites = "favorites"
    
    static let homeTimelineUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    static let userTimelineUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    static let favoritesListUrl = "https://api.twitter.com/1.1/favorites/list.json"
    
    static let timelineUrls = [Timeline.home: homeTimelineUrl, Timeline.user: userTimelineUrl, Timeline.favorites: favoritesListUrl]
}
