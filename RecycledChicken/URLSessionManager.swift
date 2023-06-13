//
//  URLSessionManager.swift
//  Marais
//
//  Created by 林書郁 on 2022/3/18.
//

import Foundation

func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void){
    let task = URLSession.shared.dataTask(with: request){(data,response,error) in
        if error != nil{
            print("url發生問題\(error.debugDescription)")
        }else{
            if data != nil {
                completion(data!)
            }else {
                print("Data is nil.")
            }
            //                guard let resultData = data else {return}
        }
    }
    task.resume()
}


func requestWithJSONBody(urlString: String, parameters: [String: Any]? = nil, AuthorizationToken:String = "", completion: @escaping (Data) -> Void){
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    if parameters != nil {
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        }catch let error{
            print(error)
        }
    }
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(AuthorizationToken, forHTTPHeaderField: "Authorization")
    fetchedDataByDataTask(from: request, completion: completion)
 }

func getJSONBody(urlString: String, parameters: [String: Any]? = nil, authorizationToken:String? = nil, completion: @escaping (Data) -> Void){
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    if parameters != nil {
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        }catch let error{
            print(error)
        }
    }
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let authorizationToken = authorizationToken {
        request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
    }
    fetchedDataByDataTask(from: request, completion: completion)
 }

func dataToDictionary(data:Data) -> Dictionary<String,Any>{
    var dic = Dictionary<String,Any>()
    do {
        let json = try JSONSerialization.jsonObject(with:data, options: .mutableContainers)
        dic = json as! Dictionary<String,Any>
    } catch  {
        print("\(error)")
    }
    return dic
}
