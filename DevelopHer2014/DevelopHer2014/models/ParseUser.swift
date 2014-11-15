import UIKit

class ParseUser:  PFUser,PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    var isPublic :Bool? {
        get {return objectForKey("isPublic") as Bool?}
        set {setObject(newValue, forKey: "isPublic")}
    }
    var name :String? {
        get {return self.firstName! + " " + self.lastName!}
     }
    var firstName :String? {
        get {return objectForKey("FirstName") as String?}
        set {setObject(newValue, forKey: "FirstName")}
    }
    var lastName :String? {
        get {return objectForKey("LastName") as String?}
        set {setObject(newValue, forKey: "LastName")}
    }
    var headline :String? {
        get {return objectForKey("HeadLine") as String?}
        set {setObject(newValue, forKey: "HeadLine")}
    }
    
    var profileImageUrl :String? {
        get {return objectForKey("profileImageURL") as String?}
        set {setObject(newValue, forKey: "profileImageURL")}
    }
    var latitude :Double? {
        get {return objectForKey("Latitude") as Double?}
        set {setObject(newValue, forKey: "Latitude")}
    }
    
    var longitude :Double? {
        get {return objectForKey("Longitude") as Double?}
        set {setObject(newValue, forKey: "Longitude")}
    }
    
    
    var Industry :String? {
        get {return objectForKey("Industry") as String?}
        set {setObject(newValue, forKey: "Industry")}
    }
    var interests : [ParseInterest] {
        get {return objectForKey("InterestType") as [ParseInterest]}
        set {setObject(newValue, forKey: "InterestType")}
    }
    
    
}

