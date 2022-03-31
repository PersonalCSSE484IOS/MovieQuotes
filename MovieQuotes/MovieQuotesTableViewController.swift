//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 3/28/22.
//

import UIKit

class MovieQuoteTableViewCell: UITableViewCell{
    
    @IBOutlet weak var MovieLabel: UILabel!
    @IBOutlet weak var QuoteLabel: UILabel!
}

class MovieQuotesTableViewController: UITableViewController {
        
    let kMovieQuoteCell = "MovieQuoteCell"
    let kMovieQuoteSegue = "MyMovieDetailView"
    //let names = ["aaaaaa","bbbbbb", "cccccccc", "dddddd","eeeeee"]
    var movieQuotes = [MovieQuote]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        navigationItem.leftBarButtonItem = editButtonItem //** add the edit button **
        
        //add + controll button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showAddQuoteDialog))
        //hardcode
        let mq1 = MovieQuote(quote:"I'll be back", movie: "The terminatr")
        let mq2 = MovieQuote(quote: "Youadrian", movie: "Rocky")
        
        movieQuotes.append(mq1)
        movieQuotes.append(mq2)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func showAddQuoteDialog(){
        print("You press the add")
        
        //add alert after click the + button
        let alertController = UIAlertController(title: "create a new Movie Quote", message: "", preferredStyle: UIAlertController.Style.alert)
        
        // add text in place
        alertController.addTextField { textField in
            textField.placeholder = "Quote in"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Movie in"
        }
        
        
        //add create and cancel button
        let createAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default) { UIAlertAction in
            print("You press create")
            let quoteTextField = alertController.textFields![0] as UITextField
            let movieTextField = alertController.textFields![1] as UITextField
            print("Quote is \(quoteTextField.text)")
            print("Movie is \(movieTextField.text)")
            let mq = MovieQuote(quote: quoteTextField.text!, movie: movieTextField.text!)
            self.movieQuotes.append(mq)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in

        }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
       
        
        
        
        present(alertController, animated: true)
    }
  
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieQuotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMovieQuoteCell, for: indexPath) as! MovieQuoteTableViewCell

         //Configure the cell...
        //cell.textLabel?.text = names[indexPath.row]
        
        cell.QuoteLabel?.text = movieQuotes[indexPath.row].quote
        cell.MovieLabel?.text = movieQuotes[indexPath.row].movie
        
        
        return cell
    }
    
    //Do delete
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movieQuotes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    

   

    
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kMovieQuoteSegue{
            let mqdvc = segue.destination as! MyMoviewQuoteDetailController
            if let indexPath = tableView.indexPathForSelectedRow{
                mqdvc.movieQuote = movieQuotes[indexPath.row]
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
