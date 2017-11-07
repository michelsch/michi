//
//  Profile.swift
//  
//
//  Created by Michel Schoemaker on 6/5/16.
//
//

import Foundation
import CoreData
import UIKit

class Profile: NSManagedObject {
    
    //the following two functions partially transcribed from https://www.udemy.com/ios9-swift/learn/v4/t/lecture/3383728?start=615
    
    func setImg(img:UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.image = data
    }
    
    func getImg() -> UIImage {
        let img = UIImage(data:self.image!)
        return img!
     }

}
