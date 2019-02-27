//
//  MemeCollectionVC.swift
//  MemeMe02
//
//  Created by nouf alharbi on 2/5/19.
//  Copyright © 2019 nouf alharbi. All rights reserved.
//

import Foundation
import UIKit
private let reuseIdentifier = "Cell"

class MemeCollectionVC: UICollectionViewController {
    
    
    
    
    @IBOutlet weak var layoutFlow: UICollectionViewFlowLayout!
   
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        layoutFlow.minimumInteritemSpacing = space
        layoutFlow.minimumLineSpacing = space
        layoutFlow.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        toggleNavAndTabBars(on: false)
        self.collectionView?.reloadData()
    }
    
    func toggleNavAndTabBars(on: Bool) {
        self.tabBarController?.tabBar.isHidden = on
        self.navigationController?.navigationBar.isHidden = on
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MemeCollectionCell
        cell.collectionCellImage.image = memes[indexPath.row].memedImage
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetails") as! MemeDetailView
        detailVC.meme = self.memes[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
