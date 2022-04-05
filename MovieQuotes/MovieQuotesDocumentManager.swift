//
//  MovieQuotesDocumentManager.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 3/31/22.
//

import Foundation
import Firebase

class MovieQuoteDocumentManager{
    //var latestMovieQuotes = [MovieQuote]()
    var latestMovieQuote : MovieQuote?
    static let shared = MovieQuoteDocumentManager()
    var _collectionRef: CollectionReference
 //   var listenerRegistration: ListenerRegistration?
    private init(){
        _collectionRef = Firestore.firestore().collection(kMovieQuotesCollectionPath)
    }
 
    
    func startListening(for documentId: String, changeListener: @escaping (()-> Void))->ListenerRegistration{
        let query = _collectionRef.document(documentId)
        return query.addSnapshotListener{documentSnapshot, error in
            guard let document = documentSnapshot else{
                return
            }
            guard let data = document.data() else{
                return
            }
            self.latestMovieQuote = MovieQuote(documentSnapshot:document)
            changeListener()
        }
    }
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        listenerRegistration?.remove()
    }
    
    func update(quote: String, movie: String){
         
        _collectionRef.document(latestMovieQuote!.documentId!).updateData([
            kMovieQuoteQuote: quote,
            kMovieQuoteMovie: movie,
            kMovieQuoteLastTouched: Timer.init(),]){
                err in
                if let err = err{
                    print("Error uodateing: \(err)")
                }else{
                    print("Document updated")
                }
            }
    }

}

