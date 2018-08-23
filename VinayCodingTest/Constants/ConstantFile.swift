//
//  ConstantFile.swift
//  VinayCodingTest
//
//  Created by Vinay on 23/08/18.
//  Copyright © 2018 Vinay. All rights reserved.
//

import Foundation

struct TableCellIDConstants {
    static let githubRepoTableViewCell = "GithubRepoTableViewCellID"
}

struct CommonAlertMessage {
    static let InternetNotAvailable = "Please check your internet connection"
    static let FetchingDataError = "There was some error fetching data"
    
}

struct ResponseCode {
    static let RequestOK  = 200
   
}

struct WebservicesURL {
    static let githubURL = "https://api.github.com/search/repositories?q=created:%@&sort=stars&order=desc"
    static let githubURLWithPagination = "https://api.github.com/search/repositories?q=created:%@&sort=stars&order=desc&page=%@"
    
    
}
