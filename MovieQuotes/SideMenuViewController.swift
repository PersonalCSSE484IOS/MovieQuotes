//
//  SideMenuViewController.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 4/29/22.
//

import Foundation
import UIKit
class SideMenuViewController: UIViewController{
    
    var tableView: MovieQuotesTableViewController{
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! MovieQuotesTableViewController
    }
    
    
    
    
    @IBAction func pressEditProfile(_ sender: Any) {
        dismiss(animated: true)
        print("show profile")
        tableView.performSegue(withIdentifier: kProfileSegue, sender: tableView)
    }

        

    
    @IBAction func pressShowMyQuote(_ sender: Any) {
        dismiss(animated: true)
        tableView.isShowingAllQuotes = false
        tableView.startListeningForMovieQuotes()
    }
    @IBAction func pressAllQuote(_ sender: Any) {
        dismiss(animated: true)
        tableView.isShowingAllQuotes = true
        tableView.startListeningForMovieQuotes()
    }
    @IBAction func pressDelete(_ sender: Any) {
        dismiss(animated: true)
        
        tableView.isEditing = !tableView.isEditing
        print("sTART TO DELETE, edit is \(tableView.isEditing)")
    }
    @IBAction func pressLogOut(_ sender: Any) {
        dismiss(animated: true)
        AuthManager.shared.signOut()
    }
}
