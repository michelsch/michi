//
//  LocatorCell.swift
//  michi
//
//  Created by Michel Schoemaker on 6/4/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//

import UIKit

class LocatorCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var phrases: AnyObject?
    var locationTitle: String?
}
