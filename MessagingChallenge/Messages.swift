//
//  Messages.swift
//  MessagingChallenge
//
//  Created by Katie Hollman on 8/16/17.
//  Copyright © 2017 Nik Flahavan. All rights reserved.
//

import Foundation

//This is a type
//customcodeconvertable
public struct Message: Codable, CustomStringConvertible {
    
    var id: Int
    var userID: Int
    var userName: String
    var firstName: String
    var lastName: String
    var messageBody: String
    
    public var description: String {
        return "\n\(id) \(userName)\n    \(messageBody)"
    }
    
}

public struct loginMessage: Codable, CustomStringConvertible {
    var message: String
    
    public var description: String {
        return "\(message)"
    }
}


