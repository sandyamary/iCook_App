//
//  Constants.swift
//  iCook
//
//  Created by Udumala, Mary on 7/11/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class DatBaseNames {
    static let Videos = "Videos"
}
class VideosDataBaseKeys {
    static let channelDescription = "channelDescription"
    static let channelId = "channelId"
    static let channelTitle = "channelTitle"
    static let etag = "etag"
    static let publishedAt = "publishedAt"
    static let thumbnailImage = "thumbnailImage"
    static let title = "title"
    static let videoID = "videoID"
    static let favourites = "favourites"
    static let navTitle = "navTitle"
}

class Constants {
    static let applicationName = "iCook"
}

func icookFBID() -> String
{
    if UserDefaults.standard.object(forKey: "FBID") != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: "FBID") as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func icookAddFBID(FBID:String)
{
    if FBID != ""
    {
        UserDefaults.standard.set(FBID, forKey: "FBID")
        UserDefaults.standard.synchronize()
    }
    else
    {
        UserDefaults.standard.removeObject(forKey: "FBID")
        UserDefaults.standard.synchronize()
    }
}

func icookPageToken(key:String) -> String
{
    if UserDefaults.standard.object(forKey: key) != nil
    {
        let kDeviceToken = UserDefaults.standard.object(forKey: key) as! String
        return kDeviceToken
    }
    else
    {
        return ""
    }
}

func icookAddPageToken(token:String,key:String)
{
    if token != ""
    {
        UserDefaults.standard.set(token, forKey: key)
        UserDefaults.standard.synchronize()
    }
    else
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension Date {
    func trimTime() -> Date {
        var boundary = Date()
        var interval: TimeInterval = 0
        _ = Calendar.current.dateInterval(of: .day, start: &boundary, interval: &interval, for: self)
        
        return Date(timeInterval: TimeInterval(NSTimeZone.system.secondsFromGMT()), since: boundary)
    }
}
class NMTextField: UITextField
{
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }else
            if action == #selector(UIResponderStandardEditActions.copy(_:))
            {
                return false
            }else
                if action == #selector(UIResponderStandardEditActions.cut(_:)) {
                    return false;
        }
        self.inputAssistantItem.leadingBarButtonGroups = []
        self.inputAssistantItem.trailingBarButtonGroups = []
        return super.canPerformAction(action, withSender: sender)
    }
}
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

@IBDesignable extension UIView {
    
    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
}
extension String
{
    func substring(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            return ""
        }
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        return self.substring(with: range)
    }
    
    func substring(start: Int, location: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            return ""
        }
        else if location < 0 || start + location > self.characters.count
        {
            return ""
        }
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: start + location)
        let range = startIndex..<endIndex
        return self.substring(with: range)
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

extension UILabel {
    func setHTMLFromString(htmlText: String,colorCode:String,size:NSInteger) {
        
        let modifiedFont = NSString(format:"<span style=\"font-family: Raleway; font-size: \(size); color: %@\">%@</span>" as NSString,colorCode, htmlText) as String
        let attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        let text = htmlText
        let types: NSTextCheckingResult.CheckingType = .link
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.characters.count))
            for item in 0..<matches.count {
                let _ = matches[item].url
                //let check = attrStr.setAsLink(textToFind: (url?.absoluteString)!, linkURL: (url?.absoluteString)!)
            }
        } catch {
            // none found or some other issue
            print ("error in findAndOpenURL detector")
        }
        self.attributedText = attrStr
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
            return formatter
        }()
    }
    
    var iso8601: String {
        var data = Formatter.iso8601.string(from: self)
        if let fractionStart = data.range(of: "."),
            let fractionEnd = data.index(fractionStart.lowerBound, offsetBy: 7, limitedBy: data.endIndex) {
            let fractionRange = fractionStart.lowerBound..<fractionEnd
            let intVal = Int64(1000000 * self.timeIntervalSince1970)
            let newFraction = String(format: ".%06d", intVal % 1000000)
            data.replaceSubrange(fractionRange, with: newFraction)
        }
        return data
    }
}

extension String {
    var dateFromISO8601: Date? {
        
        var preliminaryDate = Date.Formatter.iso8601.date(from: self)
        
        if let fractionStart = self.range(of: "."),
            let fractionEnd = self.index(fractionStart.lowerBound, offsetBy: 7, limitedBy: self.endIndex)
        {
            let fractionRange = fractionStart.lowerBound..<fractionEnd
            let fractionStr = self.substring(with: fractionRange)
            if var fraction = Double(fractionStr) {
                let intVal = Int64(fraction * 1000000) % 1000
                fraction = Double(intVal) / 1000000.0
                preliminaryDate?.addTimeInterval(fraction)
            }
        }
        return preliminaryDate
    }
}    




