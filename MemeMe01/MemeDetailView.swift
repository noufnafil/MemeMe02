//
//  MemeDetailView.swift
//  MemeMe02
//
//  Created by nouf alharbi on 2/5/19.
//  Copyright © 2019 nouf alharbi. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailView:UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memeImage.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
        
    }
}
