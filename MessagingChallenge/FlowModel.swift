//
//  FlowModel.swift
//  MessagingChallenge
//
//  Created by Katie Hollman on 8/25/17.
//  Copyright © 2017 Nik Flahavan. All rights reserved.
//

import Foundation
import UIKit

func hasBeenLoggedIn(fireUser: FireUser?, _ completionHandler: @escaping (() -> Void)) {
    let userDefaults = UserDefaults.standard
    fireUser?.userToken = userDefaults.object(forKey: "user-auth-token") as! String
    fireUser?.populateMessages(){
        print("hello from hasBeenLoggedIn closure! messages.count: \(fireUser?.messages.count ?? 0)")
        completionHandler()
    }
    
    
}

func WantsToBeLoggedIn(FireUser: FireUser?) {

}
