//
//  ViewControllerModel.swift
//  VinayCodingTest
//
//  Created by Vinay on 23/08/18.
//  Copyright © 2018 Vinay. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire
import MBProgressHUD


typealias APIResult = (Bool,Any?,String?) -> ()

enum HTTPMethodType:Int {
    case GET = 1
    case POST = 2
    case PUT = 3
    case DELETE = 4
}

class APIManager: NSObject {
    
    
    //MARK: - Properties
    
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        
        // setup code
        
        return instance
    }()
    
    //MARK: - Private Methods
    
    private func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //MARK: - Public Methods
   
    public func apiRequest(url:String, method: HTTPMethodType, parameters: [String:Any]?, headers:[String:String]?, parentViewController: UIViewController, showProgress: Bool = true, completion:@escaping APIResult) {
        
        //Check if internet is available
        if !self.connectedToNetwork() {
            completion(false, nil, CommonAlertMessage.InternetNotAvailable)
            return
        }
        //Show progress view
        if showProgress {
            DispatchQueue.main.async {
                 MBProgressHUD.hide(for: parentViewController.view, animated: true)
                 MBProgressHUD.showAdded(to: parentViewController.view, animated: true)
            }
           
        }
        
        var httpMethodValue: HTTPMethod!
        switch method {
        case HTTPMethodType.GET:
            httpMethodValue = HTTPMethod.get
            break
        case HTTPMethodType.POST:
            httpMethodValue = HTTPMethod.post
            break
        case HTTPMethodType.PUT:
            httpMethodValue = HTTPMethod.put
            break
        case HTTPMethodType.DELETE:
            httpMethodValue = HTTPMethod.delete
            break
        }
        
        print("parameters = \(String(describing: parameters))")
        Alamofire.request(url, method: httpMethodValue, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print("Request = \(String(describing: response.request))")
                print("Response = \(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)))")
                print("API Response = \(response)")
                
                //Hide progress view
                
                if showProgress {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: parentViewController.view, animated: true)
                    }
                }
                
                var message: String!
                do {
                    guard let data = response.data else { return }
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    message = json["message"] as? String
                } catch let error as NSError {
                    print(error)
                }
                
                //Check for the response result and take actions
                switch(response.result) {
                case .success:
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case ResponseCode.RequestOK:                     //200
                            completion(true, response.result.value, message)
                            return
                        
                        default:
                            message = String(data: response.data!, encoding: String.Encoding.utf8)
                            break
                        }
                    }
                    completion(false, nil, message)
                    break
                case .failure:
                    message = CommonAlertMessage.FetchingDataError
                    if response.error != nil {
                        let responseString = String(data: response.data!, encoding: String.Encoding.utf8)!
                        if !responseString.isEmpty {
                            message = responseString
                        } else {
                            message = response.error?.localizedDescription
                        }
                    }
                    completion(false, nil, message)
                    return
                }
        }
        
    }
    
    
}

