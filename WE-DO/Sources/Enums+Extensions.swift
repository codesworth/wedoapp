//
//  Enums+Extensions.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 06/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit


extension UIColor{
    
    static public var primary:UIColor{
        return UIColor(red:0.08, green:0.56, blue:0.88, alpha:1)
    }
    
    static public var primaryLight:UIColor{
        return UIColor(red: 48/255, green: 172/255, blue: 1, alpha: 1)
    }
    
    static public var wd_ash:UIColor{
        return UIColor("#9A9A9A")
    }
   
    static public var wd_yellow:UIColor{
        return UIColor("#E08C14")
    }
    
}


enum Identifiers:String{
    case segue_tohome = "tohome";
}



func createDefaultAlert(_ title:String, _ message:String, _ style:UIAlertController.Style = .alert, _ actionTitle:String, _ actionStyle:UIAlertAction.Style = .default, _ handler: CompletionHandlers.alert?) -> UIAlertController{
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: handler)
    alert.addAction(action)
    return alert
}


enum CompletionHandlers{
    typealias alert = (_ alert:UIAlertAction) -> ()
    typealias dataservice = (_ success: Bool?, _ errorMessage: String?) -> ()
    
    
}

enum Aliases{
    typealias dictionary = Dictionary<String,Any>
    typealias sset = Set<String>
}

enum DateFormats:String{
    case short_t = "MM-dd-yyyy HH:mm"
    case shirt_nt = "MM/dd/yyyy"
    case year_month = "MMMM yyyy"
    case long_epoch = "E, d MMM yyyy HH:mm:ss Z"
    case no_year_t = "MMM d, h:mm a"
}



enum References:String{
    case users = "WD-USERS"
    
    case locations = "WD-Locations"
    case photos = "photos"
}

enum Fields:String{
    
    case username = "username"
    case dateCreated = "dateCreated"
    case timestamp = "timestamp"
    case profileUrl = "profileUrl"
    case phone = "phone"
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
extension UIViewController {
    func add(_ child: UIViewController, to parentView:UIView? = nil) {
        addChild(child)
        if let v = parentView{
            v.addSubview(child.view)
        }else{
            view.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }
    func removeFrom() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        removeFromParent()
        
        view.removeFromSuperview()
    }
}

extension UIToolbar {
    
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}

extension Date{
    func toStringwith(_ format:DateFormats)->String{
        let dateFomater = DateFormatter()
        dateFomater.dateStyle = .medium
        dateFomater.locale = Locale.current
        dateFomater.timeZone = TimeZone.current
        dateFomater.dateFormat = format.rawValue
        return dateFomater.string(from: self)
    }
}

