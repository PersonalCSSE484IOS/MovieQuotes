//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 3/28/22.
//

import UIKit
import Firebase
class MovieQuoteTableViewCell: UITableViewCell{
    
    @IBOutlet weak var MovieLabel: UILabel!
    @IBOutlet weak var QuoteLabel: UILabel!
}

class MovieQuotesTableViewController: UITableViewController {
        
    let kMovieQuoteCell = "MovieQuoteCell"
    let kMovieQuoteSegue = "MyMovieDetailView"
    var movieQuotesListenerRegistration: ListenerRegistration?
    
    var isShowingAllQuotes = true
    var logoutHandle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                                                 target: self,
                                                                 action: #selector(showAddQuoteDialog))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☰",
//                                                                 style: UIBarButtonItem.Style.plain,
//                                                                 target: self,
//                                                                 action: #selector(showMenue))
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeningForMovieQuotes()
        logoutHandle = AuthManager.shared.addLogoutObserver {
            print("Someone sign out, go back to LoginViewController")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningForMovieQuotes()
        AuthManager.shared.removeObserver(logoutHandle)
    }
    
    func startListeningForMovieQuotes(){
//        movieQuotesListenerRegistration = MovieQuotesCollectionManager.shared.startListening{
//            self.tableView.reloadData()
//        }
        stopListeningForMovieQuotes()// does nothing the 1st time, stop the last listener
        movieQuotesListenerRegistration = MovieQuotesCollectionManager.shared.startListening(filterByAuthor: isShowingAllQuotes ? nil : AuthManager.shared.currentUser?.uid)
        {
            self.tableView.reloadData()
        }
    }
    
    func stopListeningForMovieQuotes(){
        MovieQuotesCollectionManager.shared.stopListening(movieQuotesListenerRegistration)
    }
    
    @objc func showMenu(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let showAddQuote = UIAlertAction(title: "Add Quote", style: UIAlertAction.Style.default) { UIAlertAction in
            self.showAddQuoteDialog()
        }
        
        let showMyQuote = UIAlertAction(title: isShowingAllQuotes ? "Show my Quote" : "Show all quotes", style: UIAlertAction.Style.default) { UIAlertAction in
            self.isShowingAllQuotes = !self.isShowingAllQuotes
            self.startListeningForMovieQuotes()
        }
        
        let signOut = UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.default) { UIAlertAction in
            print("You signed out")
            AuthManager.shared.signOut()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
        }
        alertController.addAction(showAddQuote)

        alertController.addAction(showMyQuote)

        alertController.addAction(signOut)

        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc func showAddQuoteDialog(){
        print("You press the add")
        let alertController = UIAlertController(title: "create a new Movie Quote", message: "", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField { textField in
            textField.placeholder = "Quote in"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Movie in"
        }
        let createAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default) { UIAlertAction in
            print("You press create")
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote is \(quoteTextField.text)")
            print("Movie is \(movieTextField.text)")
            let mq = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
            MovieQuotesCollectionManager.shared.add(mq)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
        }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
  
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let mq = MovieQuotesCollectionManager.shared.latestmovieQuotes[indexPath.row]
        return AuthManager.shared.currentUser?.uid == mq.authorUid
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieQuotesCollectionManager.shared.latestmovieQuotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMovieQuoteCell, for: indexPath) as! MovieQuoteTableViewCell
        let mq = MovieQuotesCollectionManager.shared.latestmovieQuotes[indexPath.row]
        cell.QuoteLabel.text = mq.quote
        cell.MovieLabel.text = mq.movie
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: Implement delete
            let mqToDelete = MovieQuotesCollectionManager.shared.latestmovieQuotes[indexPath.row]
            MovieQuotesCollectionManager.shared.delete(mqToDelete.documentId!)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kMovieQuoteSegue{
            let mqdvc = segue.destination as! MyMoviewQuoteDetailController
            if let indexPath = tableView.indexPathForSelectedRow{
            //    mqdvc.movieQuote = movieQuotes[indexPath.row]
                //TODO: Inform the detail view about the moviequote
                let mq = MovieQuotesCollectionManager.shared.latestmovieQuotes[indexPath.row]
                mqdvc.movieQuoteDocumentId = mq.documentId!
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    

}
