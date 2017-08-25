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
    var userToken: String
    var messages: [Message]
    
    init() {
        id = 0
        userName = ""
        userToken = ""
        messages = []
    }
    
    
    func messagesAt(indexPath: IndexPath) -> Message{
        if (indexPath.row >= messages.count) {
            return messages[0]
        }
        
        return self.messages[indexPath.row]
    }
    
    
    /*
         This function takes the username and password provided and logs into the fireside server.
         It needs string optionals for username and password (It will check to make sure they aren't nil or empty) and it returns a boolean, true if login was sucessful, and false if it wasn't

    */
    func login(userName: String?, password: String?, completionHandler: @escaping (() -> Void)) {
        
        guard let newName = userName else {
            return
        }
        guard let newPassword = password else {
            return
        }
        if newName.isEmpty || newPassword.isEmpty{
            return
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
            print("start of login closure")
            
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
                
                let defaults = UserDefaults.standard
                defaults.set(self.userToken, forKey: "user-auth-token")
                
                print("userToken: \(self.userToken)\nuserName: \(self.userName)")
                
                DispatchQueue.main.sync {
                    print("Hello from DispatchQueue.main.sync, about to head to closure.")
                    completionHandler()
                }
            default:
                print("In case: deafault.\nWeird Status: \(status)")
            }
            print("end of login closure")
            
            
        }
        
        task.resume()
        print("after login resume()")
        
        return
    }
    
    /*
         Login should already be done.  Use the user token to hit the server and get the messages
     */
    func populateMessages (completionHandler: @escaping (() -> Void)) {
        //The url we want to hit to login
        let url = URL(string: "http://198.150.10.30:8080/fireside/messages")
        //The request object
        var request = URLRequest(url: url!)
        
        //filling out the request object per protocol
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(self.userToken)", forHTTPHeaderField: "user-auth-token")
        
        let session = URLSession.shared
        //Hitting the server and resulting work...
        let task = session.dataTask(with: request) { (data, response, error) in
            
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
            case .ok:
                //In case ok. Do what you came here to do.
                guard let returnedData = data else {
                    print("no data returned")
                    return
                }
                
                //JSON Decoder
                let decoder = JSONDecoder()
                //try? converts error handling into optional which is easier to work with...
                //"we tell it we want actual type by referring to .self"
                let newMessages = try? decoder.decode([Message].self, from: returnedData)
                
                //getting new messages...
                self.messages = newMessages ?? []
                
                DispatchQueue.main.sync {
                    completionHandler()
                }
            default:
                print("In case: deafault.\nWeird Status: \(status).  userToken: \(self.userToken)")
            }
            
        }
        
        task.resume()
    }
    
    func createNewUser(userName: String?, password: String?, firstName: String?, lastName: String?, email: String?, completionHandler: @escaping (() -> Void)) {
        print("Hello from createNewuser!")
        guard let newName = userName else {
            return
        }
        guard let newPassword = password else {
            return
        }
        guard let newFirstName = firstName else {
            return
        }
        guard let newLastName = lastName else {
            return
        }
        guard let newEmail = email else {
            return
        }
        if newName.isEmpty || newPassword.isEmpty || newFirstName.isEmpty || newLastName.isEmpty || newEmail.isEmpty{
            return
        }
        
        let url = URL(string: "http://198.150.10.30:8080/fireside/newuser")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let json = """
        {
          "password": "\(newPassword)",
          "firstName": "\(newFirstName)",
          "email": "\(newEmail)",
          "lastName": "\(newLastName)",
          "userName": "\(newName)",
          "secret": "HskVNwVy6vhffyReLpeFACoYRXbwa&sdj#zz4e#BUXPMd7nvPycrNxuLvX?>iXmzBhyDibiye6KXGb2;Fwhmv)oPEdHJsgAppWc7/{}nZQsWFWpZLWivUndeKgagbLLK"
        }
        """
        
        let jsonData = json.data(using: .utf8)
        
        request.httpBody = jsonData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard case let createResponse as HTTPURLResponse = response  else {
                print(error!)
                return
            }
            
            guard let status = HTTPStatusCode(rawValue: createResponse.statusCode) else {
                print(error!)
                return
            }
            
            switch status {
            case .created:
                print("Created")
                
                let headers = createResponse.allHeaderFields
                let userToken = headers["user-auth-token"]
                print("user auth token: \(userToken!)")
                
                self.userToken = userToken as! String
                
                let defaults = UserDefaults.standard
                defaults.set(self.userToken, forKey: "user-auth-token")
                
                DispatchQueue.main.sync {
                    print("Hello from DispatchQueue.main.sync, about to head to closure.")
                    completionHandler()
                }
                
            default:
                print("\(status)")
            }
            
        }
        task.resume()
        
    }
    
    
}
