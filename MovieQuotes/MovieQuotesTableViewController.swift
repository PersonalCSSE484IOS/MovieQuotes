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
    //let names = ["aaaaaa","bbbbbb", "cccccccc", "dddddd","eeeeee"]
    var movieQuotes = [MovieQuote]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem //** add the edit button **
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(showAddQuoteDialog))
        //hardcode
        let mq1 = MovieQuote(quote:"I'll be back", movie: "The terminatr")
        let mq2 = MovieQuote(quote: "Youadrian", movie: "Rocky")
        
        movieQuotes.append(mq1)
        movieQuotes.append(mq2)
    }
    
    @objc func showAddQuoteDialog(){
        print("You press the add")
        
        let alertController = UIAlertController(title: "create a new Movie Quote", message: "", preferredStyle: UIAlertController.Style.alert)
        
        
        let createAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default) { UIAlertAction in
            print("Youpr press create")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
            print("Youpr press cancel")
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
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
