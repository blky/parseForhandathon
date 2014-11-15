//
//  LoginViewController.swift
//  DevelopHer2014
//
//  Created by Maricel Quesada on 11/14/14.
//  Copyright (c) 2014 Maricel-Betsy-Cindy-Alexa-Diana. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var linkedInClient: LinkedInClient!
    var userObjId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.linkedInClient = LinkedInClient.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShowCategories(sender: AnyObject) {
        
        var cat = ParseCategory.query() as PFQuery
        cat.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!,error: NSError!) -> Void in
            
            for obj in objects {
                var category = obj as ParseCategory
                println("categories are \(category.name!)")
            }
        }
        
    }
    @IBAction func onLogout(sender: UIButton) {
       
        User.currentUser?.logout()
     }

    @IBAction func onAddInterest(sender: AnyObject) {
        
        var intQuery = ParseInterest.query() as PFQuery
        intQuery.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!,error: NSError!) -> Void in
            
            for obj in objects {
                var interest = obj as ParseInterest
                println("interests are \(interest.name!)")
            }
        }
        
    }
    
    @IBAction func connectToLinkedIn(sender: AnyObject) {
        User.loginWithCompletion { () -> Void in
            println("User logged in")
        }
    }
    @IBAction func onShowUserwithsameInterest(sender: AnyObject) {
    
//        listAllUserInterestList()
    listCurrentUserInterests()
    
    }
    
    func listCurrentUserInterests(){
        var interestList = NSMutableArray();
        
        var query = PFUser.query() as PFQuery
        query.whereKey("username", equalTo: User.currentUser?.email)
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            if objects.count == 1 {
                var parseUser = objects[0] as ParseUser
                var relation = parseUser.relationForKey("InterestType")
                relation.query().findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, errpr: NSError!) -> Void in
                    if error != nil {
                        println("error getting interests")
                    } else {
                        for obj in objects {
                            let interest = obj as ParseInterest
                            interestList.addObject(obj.name!)
                            
                        }
                        println("\n[\(interestList) ]>>>>>> \(__FILE__.pathComponents.last!) >> \(__FUNCTION__) < \(__LINE__) >")

//                        self.listAllUserMatchInterestList(interestList)
                        println("current user interests: \(interestList)")
                        
                    }
                })
                
                
            } else {
                
            }
        }
    }
    func listAllUserMatchInterestList (interestList:NSArray) {
        println("\n[\(interestList) ]>>>>>> \(__FILE__.pathComponents.last!) >> \(__FUNCTION__) < \(__LINE__) >")
        var allUserandtheirInterests = NSMutableArray()
        var interestList = NSMutableArray()
         var query = ParseUser.query()
        
         var matchUsers : [ParseUser]?
        
        query.findObjectsInBackgroundWithBlock { (objects :[AnyObject]!, error : NSError!) -> Void in
            if error == nil {
                for obj in objects {
                    let parseUser =  obj as ParseUser
                    var relation = parseUser.relationForKey("InterestType")
                    relation.query().findObjectsInBackgroundWithBlock({ (interestObjects:[AnyObject]!, InterestError: NSError!) -> Void in
                        
                        for obj in interestObjects {
                            let interest = obj as ParseInterest
                            
                            for eachInt in interestList {
                                println("\n[ ]>>>>>> \(__FILE__.pathComponents.last!) >> \(__FUNCTION__) < \(__LINE__) >")

                                if eachInt as NSString == interest.name  {
                                    //there is a match
                                    println("interest match name : \(interest.name!)")
                                    
                                    matchUsers?.append(parseUser)
                                    break
                                }
                            }
                         }
                        
                        var temp = NSString(string: "\(interestList)")
//                        var singleUserInfo = ["userName" : parseUser.name!, "allInterests": interestsStringList]
//                        println("user : \(singleUserInfo)")
                        
                    })
                }
                
                
            } else {
                println("list user error")
            }
            
        }
        

    }
    
    func listAllUserInterestList ( ) {
         var allUserandtheirInterests = NSMutableArray()
        var interestList = NSMutableArray()
        var interestsStringList = ""
        var query = ParseUser.query()
        query.findObjectsInBackgroundWithBlock { (objects :[AnyObject]!, error : NSError!) -> Void in

            if error == nil {
                for obj in objects {
                    let parseUser =  obj as ParseUser

                    var relation = parseUser.relationForKey("InterestType")
                    relation.query().findObjectsInBackgroundWithBlock({ (interestObjects:[AnyObject]!, InterestError: NSError!) -> Void in
                        interestsStringList = ""

                        for obj in interestObjects {
                            let interest = obj as ParseInterest

                          interestsStringList = interestsStringList   + "," +  interest.name!
                        }
                        
                          var temp = NSString(string: "\(interestList)")
                          var singleUserInfo = ["userName" : parseUser.name!, "allInterests": interestsStringList]
                        println("user : \(singleUserInfo)")
                        
                    })
                }
                
                
            } else {
                println("list user error")
            }
            
        }
 
        
    }
    
    @IBAction func onAddInterestedToUser(sender: UIButton) {
        
         let InterestedObjectId = "pBI2Pfbn1r"
        let CategoryObjectId = "DT7ql1hboY"
    
        var query = PFUser.query() as PFQuery
        query.whereKey("username", equalTo: User.currentUser?.email)
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if objects.count == 1 {
                var parseUser = objects[0] as ParseUser
                 //add interest
                var relation = parseUser.relationForKey("InterestType")
                var interest = ParseInterest.query() as PFQuery
                interest.getObjectInBackgroundWithId(InterestedObjectId, block: { (object:PFObject!, error: NSError!) -> Void in
                    if object != nil {
                        
                        relation.addObject(object )
                        println("getting interest by id \(InterestedObjectId)")

                        parseUser.saveEventually()
                        println("save interest")
                    } else {
                        println("adding interest fail")
                    }
                    
                })
                
                var interestQuery = relation.query()
                interestQuery.whereKey("objectId", equalTo: InterestedObjectId)
                
             } else {
                println("error getting user iwth object id")
            }
            
        }
        
    }


}
