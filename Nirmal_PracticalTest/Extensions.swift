//
//  Extensions.swift
//  Nirmal_PracticalTest
//
//  Created by cdp on 24/07/21.
//

import Foundation
import UIKit



extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

extension String {
    
    public static func dateconversion(oldFormateDate: String) -> String {

        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:oldFormateDate)!
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
}
