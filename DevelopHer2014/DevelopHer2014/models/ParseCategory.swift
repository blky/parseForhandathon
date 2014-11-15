 
import UIKit

class ParseCategory: PFObject,PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    class  func  parseClassName() -> String! {
        return "Categories"
    }
    override class func query() -> PFQuery! {
        return PFQuery(className: "Categories")
    }
    
    
    var name:String? {
        get {return objectForKey("Name") as String? }
        set {setObject(newValue, forKey: "Name") }
    }
    
    
}