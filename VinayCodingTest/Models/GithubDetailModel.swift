//
//  GithubDetailModel.swift
//  VinayCodingTest
//
//  Created by Vinay on 23/08/18.
//  Copyright © 2018 Vinay. All rights reserved.
//

import UIKit

struct GithubDetailModelKeys {
    
    static let Name = "name"
    static let Description = "description"
    static let Stargazers_count = "stargazers_count"
    static let Fullname = "full_name"
    
}

class GithubDetailModel: NSObject {
    
     var name =  String()
     var descrption = String()
     var stargazersCount = Int()
     var fullName = String()
    
    
    override init() {
    }
     init(githubDict: [String:Any]) {
        
        name = githubDict[GithubDetailModelKeys.Name] as? String ?? ""
        descrption = githubDict[GithubDetailModelKeys.Description] as? String ?? ""
        stargazersCount = githubDict[GithubDetailModelKeys.Stargazers_count] as? Int ?? 0
        fullName = githubDict[GithubDetailModelKeys.Fullname] as? String ?? ""
        
        
        
    }

}
