//
//  Constants.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

enum Icons {
    static let addIcon          = UIImage(systemName: "plus")!
    static let editIcon         = UIImage(systemName: "square.and.pencil")!
    static let rightArrowIcon   = UIImage(systemName: "chevron.right")!
    static let addPersonIcon    = UIImage(systemName: "person.crop.circle.badge.plus")!
}


enum Images {
    static let defaultPhoto = UIImage(named: "default_photo")!
}


enum Colors {
    static let absoluteWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let absoluteBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
}

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale
    
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale >  scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale >  scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .phone && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
