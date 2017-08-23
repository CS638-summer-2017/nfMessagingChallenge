//
//  FireUser.swift
//  MessagingChallenge
//
//  Created by Katie Hollman on 8/16/17.
//  Copyright © 2017 Nik Flahavan. All rights reserved.
//

import Foundation

class FireUser {
    let id: Int
    let userName: String
    let password: String
    let userToken: String
    let messages: [Message]
    
    init() {
        id = 0
        userName = ""
        password = ""
        userToken = ""
        messages = []
    }
    
    func login(userName: String?, password: String?) {
        //we'll get this as a result of logging in
        let userToken: String
        //The url we want to hit to login
        let url = URL(string: "http://198.150.10.30:8080/fireside/login/")
        //The request object
        var request = URLRequest(url: url!)
        
        //filling out the request object per protocol
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBodyData = """
    {
    "userName": "nflahavan",
    "password": "goodPassword"
    }
    """
        request.httpBody = httpBodyData.data(using: String.Encoding.utf8)
        
        //The shared session object...
        let session = URLSession.shared
        
        //Hitting the server and resulting work...
        let task = session.dataTask(with: request) { (data, response, error) in
            print("start of closure")
            
            //Getting the response...
            guard case let messageResponse as HTTPURLResponse = response else {
                print("Invalid response from server \(String(describing: response))")
                return
            }
            
            //getting the status...
            guard let status = HTTPStatusCode(rawValue: messageResponse.statusCode) else {
                print("A really strange thing happened.")
                return
            }
            
            //If we're here, now we have a message response, and a status!!
            let header = messageResponse.allHeaderFields
            //Finding out what the status was...
            switch status {
            case .created:
                print("created")
                //Default "bucket" data
                guard let returnedData = data else {
                    print("no data returned")
                    return
                }
                
                //JSON Decoder
                let decoder = JSONDecoder()
                //try? converts error handling into optional which is easier to work with...
                //"we tell it we want actual type by referring to .self"
                let returnedMessage = try? decoder.decode([loginMessage].self, from: returnedData)
                
                print(returnedMessage ?? String(describing: returnedData))
            default:
                print("Weird Status: \(status)")
            }
        }
        
        task.resume()
        print("after resume()")
    }
}
