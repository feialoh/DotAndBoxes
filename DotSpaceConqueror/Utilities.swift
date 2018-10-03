//
//  Utilities.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 30/11/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    static var messageFrame = UIView()
    
    class func ColorCodeRGB(_ rgbValue: UInt)-> UIColor
    {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: 1.0)
    }
    
    
    class func getDefaultValue(_ key:String) -> AnyObject
    {
        
    let value = UserDefaults.standard.value(forKey: key)
    return value! as AnyObject
    
    }
    
    class func storeDataToDefaults(_ keyName:String, data:AnyObject)
    {
        if !data.isKind(of: NSNull.classForCoder())
        {
            let defaults: UserDefaults = UserDefaults.standard
            defaults.setValue(data, forKey: keyName)
            defaults.synchronize()
        }
    
    }
    
    class func checkValueForKey(_ keyName:String) -> Bool
    {
        if (UserDefaults.standard.object(forKey: keyName) != nil) {
            return true
        }else {
            return false
        }
    }
    
    class func getMyNavTitleView_old(_ appName:String) -> UIView
    {
        var viewWidth:CGFloat //, margin:CGFloat
        
        viewWidth = UIScreen.main.bounds.size.width * 0.6
        
        let navView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: NAVBAR_HEIGHT))
        
        let label:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: NAVBAR_HEIGHT))
        
        label.text = appName
        label.font = Utilities.myFontWithSize(FONT_SIZE)
        label.textColor = UIColor.white
        label.resizeLabelToFit(FONT_SIZE)
        let imageView:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 5, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        imageView.isUserInteractionEnabled = false
        navView.addSubview(imageView)
        navView.addSubview(label)
        
        let navX = (navView.frame.size.width - (imageView.frame.width+label.frame.size.width+10))/2
        imageView.frame = CGRect(x: navX, y: imageView.frame.origin.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
        
        label.frame = CGRect(x: imageView.frame.origin.x+imageView.frame.width+10, y: (NAVBAR_HEIGHT-label.frame.size.height)/2, width: label.frame.size.width, height: label.frame.size.height)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        
        return navView
        
        
    }
    
    
    
    class func getMyNavTitleView(_ appName:String) ->UIView {
        
        
        let appNameLabel = UILabel.init()
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.text = appName
        appNameLabel.isOpaque = false
        appNameLabel.backgroundColor = UIColor.clear
        appNameLabel.font = Utilities.myFontWithSize(FONT_SIZE)
        appNameLabel.textColor = UIColor.white
        appNameLabel.resizeLabelToFit(FONT_SIZE)
        
        let v  = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        // add your views and set up all the constraints
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(appNameLabel)
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        let appImage = UIImage(named: "logo")
        
        var viewsDict = Dictionary<String,AnyObject>()
        
        
        if ((appImage) != nil) {
            
            let appImageView = UIImageView.init(image: appImage)
            viewsDict = ["appImageView": appImageView,"appNameLabel": appNameLabel] as [String : AnyObject]
            
            titleView.addSubview(appImageView)
            appImageView.translatesAutoresizingMaskIntoConstraints = false
            constraints = NSLayoutConstraint.constraints(
                withVisualFormat: "|[appImageView]-15-[appNameLabel]|",
                options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: viewsDict)
                
            titleView.addConstraints(constraints)
            
            constraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[appImageView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDict)
            
            titleView.addConstraints(constraints)
            
            titleView.frame = CGRect(x: 0, y: 0, width: appImageView.frame.size.width + 7 + appNameLabel.intrinsicContentSize.width, height: appImageView.frame.size.height)
            
        } else {
            
            viewsDict = ["appNameLabel": appImage] as [String : AnyObject]
            
            constraints = NSLayoutConstraint.constraints(
                withVisualFormat: "|[appNameLabel]|",
                options: NSLayoutConstraint.FormatOptions.alignAllTop, metrics: nil, views: viewsDict)
            
            titleView.addConstraints(constraints)
            
            constraints = NSLayoutConstraint.constraints(
                withVisualFormat:"V:|[appNameLabel]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDict)
            
            titleView.addConstraints(constraints)
            
            titleView.frame = CGRect(x: 0, y: 0, width: appNameLabel.intrinsicContentSize.width, height: appNameLabel.intrinsicContentSize.height)
            
        }
        
        // This is the magic sauce!
        titleView.layoutIfNeeded()
        titleView.sizeToFit()
        
        // Now the frame is set (you can print it out)
        titleView.translatesAutoresizingMaskIntoConstraints = true // make nav bar happy
        
        return titleView;
    }
    
    class func myFontWithSize(_ size:CGFloat) -> UIFont
    {
    
     return UIFont(name: "NotSoStoutDeco", size: size)!

    }
    
    //Adjust playerturn label
    class func adjustTurnLabel(_ fontSize:CGFloat, myLabel:UILabel)
    {
        
    let myStringSize: CGSize = myLabel.text!.size(withAttributes: [NSAttributedString.Key.font: Utilities.myFontWithSize(fontSize)])
    myLabel.frame = CGRect(x: (UIScreen.main.bounds.size.width-myStringSize.width)/2,y: NAVBAR_HEIGHT+myStringSize.height+MARGIN,width: 2*myStringSize.width , height: myStringSize.height);
    }
    
    
    class func loadViewFromNib(_ viewName:String,atIndex:Int, aClass:AnyClass, parent:NSObject) -> AnyObject {
        
        let bundle = Bundle(for: aClass)
        
        let nib = UINib(nibName: viewName, bundle: bundle)
        
        let view = nib.instantiate(withOwner: parent, options: nil)[atIndex]
        
        return view as AnyObject
        
    }
    
    /*class func filterString(_ myString:String) -> String
    {
        if myString.range(of: "$#$#$-")?.first != nil
        {
          return myString.substring(to: (myString.range(of: "$#$#$-")?.first)!)
        }
        else
        {
           return myString
        }
        
    }*/
    
    
    
    class func filterString(_ str:String) ->String
    {
        
        if str.range(of: "$#$#$-") != nil{
            let equalRange: Range = (str.range(of: "$#$#$-"))!
            var result:String = String(str.prefix(upTo: equalRange.lowerBound))
            
            if result.count > NAME_LENGTH
            {
                result = String(result.prefix(NAME_LENGTH))
            }
            return result
        }
        else
        {
            return str
        }
    }
    
    class func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        
        #if DEBUG
        
        var idx = items.startIndex
        let endIdx = items.endIndex
        
        repeat {
            Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
            idx += 1
        }
            while idx < endIdx
        
        #endif
    }
    
    class func showAlertViewMessageAndTitle(_ message:String, title:String, delegate:Any?, cancelButtonTitle:String) -> UIAlertController
    {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        return alertController
        
    }
    
    
    
    class func myActivityIndicator(_ msg:String, _ view:UIView ) {
        
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        strLabel.font = Utilities.myFontWithSize(FONT_SIZE)
        strLabel.resizeLabelToFit(FONT_SIZE)
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        messageFrame = UIView(frame: CGRect(x:0, y: 0, width: strLabel.frame.size.width+60, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)


        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)
        
        strLabel.frame = CGRect(x: strLabel.frame.origin.x, y: (messageFrame.frame.size.height - strLabel.frame.size.height)/2, width: strLabel.frame.size.width, height: strLabel.frame.size.height)
        
        messageFrame.frame = CGRect(x: view.frame.midX-messageFrame.frame.size.width/2, y: view.frame.midY - 25, width: messageFrame.frame.size.width, height: 50)
        messageFrame.tag = 777
        view.addSubview(messageFrame)
    }

    class func hideMyActivityIndicator()
    {
        messageFrame.removeFromSuperview()
    }

}

extension UILabel {
    func resizeLabelToFit(_ fontSize: CGFloat) {
        
        let labelString:NSString = self.text! as NSString
        let myStringSize:CGSize = labelString.size(withAttributes: [NSAttributedString.Key.font:Utilities.myFontWithSize(fontSize)])
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: myStringSize.width, height: myStringSize.height)

    }
}
