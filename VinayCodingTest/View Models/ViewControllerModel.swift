//
//  ViewControllerModel.swift
//  VinayCodingTest
//
//  Created by Vinay on 23/08/18.
//  Copyright © 2018 Vinay. All rights reserved.
//

import UIKit

class ViewControllerModel: NSObject {
    
    var githubDetailModelArray = [GithubDetailModel]()
    
    
    //MARK: - API Call Methods
    
    public func getGithubListData(isPaginationEnabled : Bool , pageNo : String ,parentViewController: UIViewController, completionBlock:@escaping APIResult) {
        
        //Construct header to pass to api call
        let headers: [String:String] = ["Content-Type":"application/json"]
        
        //Construct get user detail url
        var  getGithubListDataURL = String()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if isPaginationEnabled{
             getGithubListDataURL = String(format:WebservicesURL.githubURLWithPagination, dateFormatter.string(from: Date()),pageNo)
        }
        else{
           getGithubListDataURL = String(format:WebservicesURL.githubURL, dateFormatter.string(from: Date()))
        }
        print("User Detail URL = \(getGithubListDataURL)")
        
        //Call APIManager method to process the request
        APIManager.sharedInstance.apiRequest(url: getGithubListDataURL, method: HTTPMethodType.GET, parameters: nil, headers: headers, parentViewController: parentViewController) { (success, response, errorMessage) in
            
            print("response = \(String(describing: response))")
            
            var successValue = success
            var errorMsg = errorMessage
            
            //Get the token value if success
            if success {
                if let responseValue = response as? [String : Any] {
                    var tObject = [GithubDetailModel]()
                    
                    if let itemsArray = responseValue["items"] as? [[String : Any]] {
                        for itemDict in itemsArray {
                            
                            //Create Manufacturer object
                            let tObjectLocal = GithubDetailModel(githubDict: itemDict)
                            tObject.append(tObjectLocal)
                        }
                    }
                    self.githubDetailModelArray = tObject
                    completionBlock(true, self.githubDetailModelArray, errorMessage)
                    return
                }
                successValue = false
                errorMsg = CommonAlertMessage.FetchingDataError
            }
            
            //callback
            completionBlock(successValue, response, errorMsg)
        }
    }

}
