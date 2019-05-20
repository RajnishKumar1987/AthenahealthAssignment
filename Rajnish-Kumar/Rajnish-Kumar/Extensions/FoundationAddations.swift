//
//  FoundationAddations.swift
//  SampleApp
//
//  Created by Rajnish kumar on 14/08/18.
//  Copyright © 2018 Rajnish kumar. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    
    func toJSONObject() -> Any? {
        
        let object = try? JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.allowFragments)
        return object
    }
}


extension Dictionary {
    
    func toJSONData() -> Data? {
        
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data
    }
}

extension Bundle{
    
    var versionNumber: String{
        return infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String{
        return infoDictionary!["CFBundleVersion"] as! String
    }
    
    
}

extension UIViewController{
    
    func showLoader(onViewController:UIViewController, transparent:Bool = false){
        if let keyWindow = onViewController.view{
            if keyWindow.subviews.count > 1{
                
                let loader = keyWindow.subviews[1]
                
                if (loader.isKind(of: LoaderView.self)){
                    return
                }
            }
            let overlay = Bundle.main.loadNibNamed("LoaderView", owner: nil, options: nil)![0] as! LoaderView
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay.frame = onViewController.view.bounds
            keyWindow.addSubview(overlay)
            
        }
    }
    
    func removeLoader(fromViewController:UIViewController){
        let keyWindow = fromViewController.view
        if let _ = keyWindow,(keyWindow?.subviews.count)! > 1{
            keyWindow?.subviews.forEach({ (loader) in
                if (loader.isKind(of: LoaderView.self)){
                    let overlay = loader as! LoaderView
                    overlay.removeFromSuperview()
                }
            })
        }else{
            print("")
        }
    }
    
}

extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d", minute, second)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Int32 {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
