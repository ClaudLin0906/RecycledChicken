//
//  AlamofireManager.swift
//  Marais
//
//  Created by 林書郁 on 2022/3/18.
//

import Foundation
import Alamofire


public func alamofire(urlStr:String ,completion: @escaping((Data?) -> Void)){
    AF.request(urlStr).response(completionHandler: { response in
        switch response.result {
        case .success(let data):
            completion(data)
        case .failure(let e):
            print(e)
            completion(nil)
        }
    })
}

public func alamofireToJson(urlStr:String ,completion: @escaping(([String : Any]?) -> Void)){
    AF.request(urlStr).responseJSON(completionHandler: { response in
        switch response.result {
        case .success(let dic):
            completion(dic as? [String : Any])
        case .failure(let e):
            print(e)
            completion(nil)
        }
    })
}

public func alamofirePostJson(postURL:String ,param:[String:String],completion: @escaping([String:Any]?) -> Void){
    
    let headers:HTTPHeaders =
        [
        "Content-Type": "application/x-www-form-urlencoded"
        ]
//    let headers:HTTPHeaders =
//    [
//        "Authorization":" ",
//        "Content-Type": "application/json"
//    ]
    _ = AF.request(postURL, method: .post ,parameters: param,headers: headers).responseJSON(completionHandler: { response in
        switch response.result {
        case .success(let dic):
            completion(dic as? [String : Any])
        case .failure(let e):
            print(e)
            completion(nil)
        }
    })
}

public func alamofirePost(postURL:String ,param:String ,completion: @escaping(Data?) -> Void){
    
//    let headers:HTTPHeaders =
//        [
//        "Content-Type": "application/x-www-form-urlencoded"
//        ]
    let headers:HTTPHeaders =
    [
        "Authorization":" ",
        "Content-Type": "application/json"
    ]
    
    _ = AF.request(postURL, method: .post ,parameters: param,headers: headers).response(completionHandler: { response in
        switch response.result {
        case .success(let data):
            completion(data)
        case .failure(let e):
            print(e)
            completion(nil)
        }
    })
    
}


public func alamofireUploadPost(postURL:String ,param:[String:Any]?, imageParam:[String:UIImage]? ,completion: @escaping(String) -> Void){
    AF.upload(multipartFormData: {(multipartFormData) in
        
        if let dic = param {
            for (key ,value) in dic {
                
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                
                if let temp = value as? Data {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
            
            }
        }
        
        if let imageDic = imageParam {
            for (imagekey ,img) in imageDic {
                guard let imgData = img.jpegData(compressionQuality: 0.7) else { return }
                multipartFormData.append(imgData, withName:imagekey ,fileName:"image.jpeg" ,mimeType: "image/jpeg")
            }
        }
        
    } ,to: postURL, usingThreshold: UInt64.init() ,method: .post).responseString(completionHandler: { response in
        switch response.result {
        case .success(let str):
            print(str)
            completion(str)
        case .failure(let e):
            print(e)
        }
    })

}
