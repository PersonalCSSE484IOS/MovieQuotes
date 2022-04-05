//
//  MyMoviewQuoteeetailController.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 3/29/22.
//

import UIKit
import Firebase

class MyMoviewQuoteDetailController: UIViewController {

    @IBOutlet weak var MovieLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    //var movieQuote: MovieQuote!
    var movieQuoteDocumentId: String!
    var movieQuotesListenerRegistration: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(showEditQuoteDialoge))
    
        
        updateView()
        // Do any additional setup after loading the view.
    }
    
//    override func viewWilllAppear(_animated: Bool){
//        super.viewWilllAppear(animated)
//        updateView()
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieQuotesListenerRegistration = MovieQuoteDocumentManager.shared.startListening(for: movieQuoteDocumentId!){
            print("TODO")
            self.updateView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MovieQuoteDocumentManager.shared.stopListening(movieQuotesListenerRegistration)
    }

    func updateView(){
//        quoteLabel.text = movieQuote.quote
//        MovieLabel.text = movieQuote.movie
    //TODO: Update the view using the manager's data
//        quoteLabel.text = MovieQuoteDocumentManager.shared.latestMovieQuotes.quote
//        MovieLabel.text = MovieQuoteDocumentManager.shared.latestMovieQuotes.movie
        if let mq = MovieQuoteDocumentManager.shared.latestMovieQuote{
            quoteLabel.text = mq.quote
            MovieLabel.text = mq.movie
        }
    }
    
    @objc func showEditQuoteDialoge(){
        print("You press the add")
        
        //add alert after click the + button
        let alertController = UIAlertController(title: "Edit a new Movie Quote", message: "", preferredStyle: UIAlertController.Style.alert)
        
        // add text in place
        alertController.addTextField { textField in
            textField.placeholder = "Quote"
            //textField.text = self.movieQuote.quote
            textField.text = MovieQuoteDocumentManager.shared.latestMovieQuote?.quote
        }
        alertController.addTextField { textField in
            textField.placeholder = "Movie in"
            //textField.text = self.movieQuote.movie
            textField.text = MovieQuoteDocumentManager.shared.latestMovieQuote?.movie

        }
        
        
        //add create and cancel button
        let editAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default) { UIAlertAction in
            print("You press create")
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote is \(quoteTextField.text)")
            print("Movie is \(movieTextField.text)")
            
 //           self.movieQuote.quote = quoteTextField.text!
 //           self.movieQuote.movie = movieTextField.text!
 //           self.updateView()
            MovieQuoteDocumentManager.shared.update(quote: quoteTextField.text!, movie: movieTextField.text!)
        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
//
//        }
        alertController.addAction(editAction)
//        alertController.addAction(cancelAction)
//
        
        
        
        present(alertController, animated: true)
    }
}
