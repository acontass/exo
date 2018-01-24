//
//  StringExtension.swift
//  SchoolEvents
//
//  Created by acontass on 23/01/2018.
//  Copyright © 2018 acontass. All rights reserved.
//

import Foundation

/// String extension, contain some tools functions of String class.

extension String {
    
    /**
     Convert an UTC string date to formatted String.
     
     - returns: The formatted string of the date or nil.
     
     - parameter format: The desired returned format.
    */

    public func utcToString(to format: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if let localDate = formatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: localDate)
        }
        return nil
    }
    
    /**
     Convert an UTC string date to Date instance.
     
     - returns: A Date instance or nil.
     */
    
    public func utcToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: self)
    }
    
    /**
     Html string converted to string.
     
     - returns: A String without tags.
     */
    
    public var htmlString: String? {
        if let data = data(using: .utf8) {
            do {
                let str = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                return str.string
            }
            catch let error {
                debugPrint(error)
            }
        }
        return nil
    }

}
