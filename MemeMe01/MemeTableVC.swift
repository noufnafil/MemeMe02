//
//  MemeTableVC.swift
//  MemeMe02
//
//  Created by nouf alharbi on 2/5/19.
//  Copyright © 2019 nouf alharbi. All rights reserved.
//

import Foundation

import UIKit

class MemeTableVC: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = getAppDelegate()
        memes = appDelegate.memes
        toggleNavAndTabBars(on: false)
        self.tableView.reloadData()
    }
    
    func toggleNavAndTabBars(on: Bool) {
        self.tabBarController?.tabBar.isHidden = on
        self.navigationController?.navigationBar.isHidden = on
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! MemeTableCell
        cell.tableCellImageView?.image = memes[indexPath.row].memedImage
        cell.tableCellLabel?.text = "\(memes[indexPath.row].topText)...\(memes[indexPath.row].bottomText)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetails") as! MemeDetailView
        detailVC.meme = self.memes[indexPath.row]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func getAppDelegate() -> AppDelegate {
        let object = UIApplication.shared.delegate
        return object as! AppDelegate
        
    }
    
 
    
    
    
    
}
