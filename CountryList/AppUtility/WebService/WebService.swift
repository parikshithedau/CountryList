//
//  WebService.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit

class WebService: NSObject {

    var webTask: URLSessionTask? = nil
    var showInternetProblem = true
    var loaderView: UIView? = nil
    var apiName = ""
    var params : [String:AnyObject]? = nil
    var completionBlock: ((Bool, String?, Any?)->())? = nil
    let timeOut: TimeInterval = Double.infinity
    var type: WebServiceType = .get
    var shouldPrintLog = false

    enum WebServiceType {
        case get
        case post
        case put
    }
    
    init(showInternetProblem: Bool) {
        
        self.showInternetProblem = showInternetProblem
    }
    
    func execute(type: WebServiceType, name: String, params: [String:AnyObject]?, uploadFileKey: String? = nil, uploadData: Data? = nil, completion: ((Bool, String?, Any?)->())?) {
        
        self.completionBlock = completion
        
        if !PHReachability.shared.isConnectedToInternet {
            
            if showInternetProblem {
                
                self.completionBlock?(false, StringConstants.errNoInternet, nil)
            }
            
            return
        }
        
        self.apiName = name
        self.params = params
        self.type = type
        
        if type == .get {
            
            get()
        }
        
        if type == .post {
            
            post()
        }
        
        if type == .put {
            
            put()
        }
    }
    
    func executeGame(type: WebServiceType, name: String, params: [String:AnyObject]?, uploadFileKey: String? = nil, uploadData: Data? = nil, completion: ((Bool, String?, Any?)->())?) {
        
        self.completionBlock = completion
        
        if !PHReachability.shared.isConnectedToInternet {
            
            if showInternetProblem {
                
                self.completionBlock?(false, StringConstants.errNoInternet, nil)
            }
            
            return
        }
        
        self.apiName = name
        self.params = params
        self.type = type
        
        if type == .get {
            
            getGame()
        }
        
        
    }
    private func getGame() {
        
        var url =  self.apiName
        
        //  addExtraParameters()
        
        var strParams = ""
        
        if self.params != nil {
            
            for i in 0..<params!.keys.count {
                
                let key = (params! as NSDictionary).allKeys[i] as! String
                
                let value = params![key]
                
                if strParams.isEmpty {
                    
                    strParams = strParams + "?\(key)=\(value!)"
                }
                else{
                    
                    strParams = strParams + "&\(key)=\(value!)"
                }
            }
        }
        
        url = url + strParams
        
        guard let urlAPI = URL(string: url) else { return }
        
        let request = URLRequest(url: urlAPI)
        
        self.executeRequest(request: request)
    }
    
    private func post() {
        
        var postData: Data? = nil
        
        do {
            postData = try JSONSerialization.data(withJSONObject: self.params!, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        let url = WebConstants.appBaseUrl + self.apiName
        
        guard let urlAPI = URL(string: url) else { return }
        
        var request = URLRequest(url: urlAPI)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        self.executeRequest(request: request)
    }
    
    private func put() {
        
        var postData: Data? = nil
                
        do {
            postData = try JSONSerialization.data(withJSONObject: self.params!, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        let url = WebConstants.appBaseUrl + self.apiName
        
        guard let urlAPI = URL(string: url) else { return }
        
        var request = URLRequest(url: urlAPI)
        request.httpMethod = "PUT"
        request.httpBody = postData
        
        self.executeRequest(request: request)
    }
    
    private func get() {
        
        var url = WebConstants.appBaseUrl + self.apiName
  
        var strParams = ""
        
        if self.params != nil {
            
            for i in 0..<params!.keys.count {
                
                let key = (params! as NSDictionary).allKeys[i] as! String
                
                let value = params![key]
                
                if strParams.isEmpty {
                    
                    strParams = strParams + "?\(key)=\(value!)"
                }
                else{
                    
                    strParams = strParams + "&\(key)=\(value!)"
                }
            }
        }
        
        url = url + strParams
        
        guard let urlAPI = URL(string: url) else { return }
        
        let request = URLRequest(url: urlAPI)
        
        self.executeRequest(request: request)
    }
    
    private func executeRequest(request: URLRequest) {
        
        if !PHReachability.shared.isConnectedToInternet {
            
            if showInternetProblem {
                
                self.completionBlock?(false, StringConstants.errNoInternet, nil)
            }
            
            return
        }
        
        var finalRequest = request
            
        finalRequest.timeoutInterval = timeOut
        
        let dictHeaders = getHeaders()
        
        finalRequest.allHTTPHeaderFields = dictHeaders
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            
            self.loadRequest(finalRequest)
        }
    }
    
    func loadRequest(_ request: URLRequest) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        webTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                                
                if error == nil {
                    
                    if let responseData = data {
                        
                        do {
                            
                            guard let dictData = try JSONSerialization.jsonObject(with: responseData, options: []) as? Any else {
                                
                                self.completionBlock?(false, StringConstants.errServerProblem, nil)
                                
                                print("error reponse = \(String(data: responseData, encoding: String.Encoding.utf8) ?? "")")
                                
                                return
                            }
                            
                            self.printLog(response: dictData as Any)
                            
                            self.completionBlock?(true, nil, dictData)
                            
                        } catch {
                            
                            self.printLog(response: (String(data: responseData, encoding: String.Encoding.utf8) ?? ""))
                            
                            print(error.localizedDescription)
                            self.completionBlock?(false, StringConstants.errServerProblem, nil)
                        }
                    }
                    else {
                        
                        self.completionBlock?(false, StringConstants.errServerProblem, nil)
                    }
                }
                else {
                    
                    self.completionBlock?(false, StringConstants.errServerProblem, nil)
                }
            }
        })
        
        webTask?.resume()
    }
    
    private func getHeaders() -> [String: String] {
        
        var dictParams = [String:String]()
        
        dictParams["Content-Type"] = "application/json"
                
        return dictParams
    }
    
    func cancel() {
        
        self.webTask?.cancel()
        self.webTask = nil
    }
    
    private func printLog(response: Any) {
        
        if !self.shouldPrintLog { return }
        
        let url = WebConstants.appBaseUrl + self.apiName
        print("_______________________________________________________________")
        print("API: \(url)")
        print("________")
        print("HEADERS: \(getHeaders())")
        print("________")
        print("Parameters: ")
        print(self.params as Any)
        print("________")
        print("Response: ")
        print(response as Any)
        print("_______________________________________________________________")
    }
}
