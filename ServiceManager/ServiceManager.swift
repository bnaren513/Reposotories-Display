//
//  ServiceManager.swift
//  GithubRepositories
//
//  Created by Pradeep Sharma on 11/10/18.
//  Copyright © 2018 Pradeep Sharma. All rights reserved.
//

import Foundation

//public typealias SuccessCallback = (NSDictionary, NSError?) ->Void

public typealias SuccessCallback = (_ json: [AnyHashable: Any]?) -> Void
public typealias SuccessCallbackWithObjects = (_ objects: [Any]?) -> Void
public typealias ErrorCallback = (_ error: Error?) -> Void
public typealias ProgressBlock = (_ progress: Float) -> Void

class ServiceManager :NSObject
{
    static let sharedInstance : ServiceManager = {
        let instance = ServiceManager()
        return instance
    }()
    
    override init() {
        super.init()
    }
    func requestWithParameters(paramaters params: Any, andMethod path: String?, onSuccess: @escaping SuccessCallback, onError: @escaping ErrorCallback ) {
     //UserDefaults.standard.set(userTokenId, forKey: "userTokenId")
   
        let serviceurl = URL(string: path!)
        var request : URLRequest = URLRequest(url: serviceurl!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  
        let dataTask = URLSession.shared.dataTask(with: request) {
                        data,response,error in
                        print("anything")
                        do {
                            if let data = data,
                                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                               
                                print(jsonResult)
                                //Use GCD to invoke the completion handler on the main thread
                                DispatchQueue.main.async() {
                                    onSuccess(jsonResult as? [AnyHashable : Any])
                                }
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            onError(error.localizedDescription as? Error)
                        }
                    }
                    dataTask.resume()
    }
    
    func detaildrequestWithParameters(paramaters params: Any, andMethod path: String?, onSuccess: @escaping SuccessCallbackWithObjects, onError: @escaping ErrorCallback ) {
        //UserDefaults.standard.set(userTokenId, forKey: "userTokenId")
        
        let serviceurl = URL(string: path!)
        var request : URLRequest = URLRequest(url: serviceurl!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data,response,error in
            print("anything")
            do {
                if let data = data,
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                    
                    print(jsonResult)
                    //Use GCD to invoke the completion handler on the main thread
                    DispatchQueue.main.async() {
                        onSuccess(jsonResult as? [Any])
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                onError(error.localizedDescription as? Error)
            }
        }
        dataTask.resume()
    }
    
}
