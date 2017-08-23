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
    var userName: String
    var password: String
    var userToken: String
    let messages: [Message]
    
    init() {
        id = 0
        userName = ""
        password = ""
        userToken = ""
        messages = []
    }
    
    /*
         This function takes the username and password provided and logs into the fireside server.
         It needs string optionals for username and password (It will check to make sure they aren't nil or empty) and it returns a boolean, true if login was sucessful, and false if it wasn't
    */
    func login(userName: String?, password: String?) -> Bool{
        guard let newName = userName else {
            return false
        }
        guard let newPassword = password else {
            return false
        }
        if newName.isEmpty || newPassword.isEmpty{
            return false
        }
        
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
    "userName": "\(newName)",
    "password": "\(newPassword)"
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
            //Finding out what the status was...
            switch status {
            case .created:
                print("In case: created")
                
                let header = messageResponse.allHeaderFields
                
                self.userToken = header["user-auth-token"] as! String
                self.userName = newName
                self.password = newPassword
                print("userToken: \(self.userToken)\nuserName: \(self.userName)\npassword: \(self.password)")
            default:
                print("In case: deafault.\nWeird Status: \(status)")
            }
        }
        
        task.resume()
        print("after resume()")
        
        return true
    }
}
