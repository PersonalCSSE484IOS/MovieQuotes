//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 3/28/22.
//



import Foundation
import Firebase
class MovieQuote{
    var quote: String
    var movie: String
    var documentId: String?
    var authorUid: String?
    
    init(quote: String, movie: String){
        self.quote = quote
        self.movie = movie
    }
    
    init(documentSnapshot: DocumentSnapshot){
        self.documentId = documentSnapshot.documentID
        let data = documentSnapshot.data()
        self.quote = data?[kMovieQuoteQuote] as! String
        self.movie = data?[kMovieQuoteMovie] as! String
        self.authorUid = data?[kMovieQuoteAuthorUid] as? String? ?? ""
    }
}
