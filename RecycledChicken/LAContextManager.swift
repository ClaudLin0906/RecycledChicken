//
//  LAContextManager.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/17.
//

import Foundation
import LocalAuthentication

//func isCanEvaluatePolicy(completion: @escaping (Bool, String) -> Void){
//    let context = LAContext()
//    var error:NSError?
//    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
//        completion(true, "")
//    } else {
//        completion(false, error?.localizedDescription ?? "")
//    }
//}
//
//func evaluatePolicyAction(completion: @escaping (Bool, String) -> Void){
//    let context = LAContext()
//    context.localizedCancelTitle = "Cancel"
//    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in to your account") { result, error in
//        guard error == nil else{
//            completion(result, error?.localizedDescription ?? "")
//            return
//        }
//        if result {
//            completion(result, "")
//        } else {
//            completion(result, error?.localizedDescription ?? "")
//        }
//    }
//}

func evaluatePolicyAction(completion: @escaping (Bool, String) -> Void){
    let context = LAContext()
    context.localizedCancelTitle = "Cancel"
    var error:NSError?
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in to your account") { result, error in
            guard error == nil else{
                completion(result, error?.localizedDescription ?? "")
                return
            }
            if result {
                completion(result, "")
            } else {
                completion(result, error?.localizedDescription ?? "")
            }
        }
    } else {
        completion(false, error?.localizedDescription ?? "")
    }
}
