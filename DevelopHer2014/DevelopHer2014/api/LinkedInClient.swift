//
//  LinkedInClient.swift
//  DevelopHer2014
//
//  Created by Maricel Quesada on 11/14/14.
//  Copyright (c) 2014 Maricel-Betsy-Cindy-Alexa-Diana. All rights reserved.
//

let REDIRECT_URL = "http://maricelquesada.com"
let CLIENT_ID = "yoydeouswnqg"
let CLIENT_SECRET = "4PAleAaobXE9YXcF"
let STATE = "178E7FE9CA26148E53F8644CA05F3A0B"

class LinkedInClient {
    var parseUser = ParseUser()
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    var client: LIALinkedInHttpClient!
    
    private init() {
        var application = LIALinkedInApplication(
            redirectURL: REDIRECT_URL,
            clientId: CLIENT_ID,
            clientSecret: CLIENT_SECRET,
            state: STATE,
            grantedAccess: ["r_fullprofile", "r_network", "r_emailaddress", "r_contactinfo"])
        
        self.client = LIALinkedInHttpClient(forApplication: application, presentingViewController: nil)
    }
    
    class var sharedInstance: LinkedInClient {
        struct Static {
            static let instance = LinkedInClient()
            
        }
        return Static.instance
    }
        
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        if (User.currentUser != nil) {
            self.loginCompletion?(user: User.currentUser, error: nil)
        } else {
            self.client.getAuthorizationCode({ (code) -> Void in
                self.client.getAccessToken(code,
                    success: { (accessTokenData) -> Void in
                        var accessToken = accessTokenData["access_token"] as String
                        println("Access Token " + accessToken)
                        self.getUserProfile()
                        
                    }, failure: { (error) -> Void in
                        println("Quering accessToken failed")
                        println(error)
                    })
                
                }, cancel: { () -> Void in
                    println("Authorization cancelled by user")
                    
                }) { (error) -> Void in
                    println("Authorization failed")
                    println(error)
                    
                }
        }
    }
    
    private func getUserProfile() {
        
         var accessToken = self.client.accessToken()
        let urlString = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,picture-url,industry,email-address)?oauth2_access_token=\(accessToken)&format=json"
        self.client.GET(urlString, parameters: nil,
            success: { (request, result) -> Void in
                println("User Profile retrieved from LinkedIn")
                println(result)
                User.currentUser = User(data: result as NSDictionary)
                self.parseUser.firstName = User.currentUser?.firstName
                self.parseUser.lastName = User.currentUser?.lastName
                self.parseUser.email = User.currentUser?.email
                self.parseUser.headline = User.currentUser?.headline
                self.parseUser.Industry = User.currentUser?.industry
                self.parseUser.username = User.currentUser?.email
                self.parseUser.password = User.currentUser?.firstName
                self.parseUser.isPublic = false
                
                if let lat = User.currentUser?.location?.latitude {
                    self.parseUser.latitude = lat
                }
                
                if let long = User.currentUser?.location?.longitude {
                    self.parseUser.longitude = long
                }
                
                self.parseUser.signUpInBackgroundWithBlock({ (successed:Bool, error:NSError!) -> Void in
                    
                    if successed {
                        println("use added successfully")
                    }else{
                        println("use added :\(error)")
        
                    }
                })
            }, failure: { (request, error) -> Void in
                println("Error retrieving user profile!!")
                println(error)
            }
        )
    }
    
}