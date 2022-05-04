//
//  UserDocumentManager.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 4/29/22.
//

import Foundation
import Firebase

class UserDocumentManager{
    var _latestDocument: DocumentSnapshot?
    static let shared = UserDocumentManager()
    var _collectionRef: CollectionReference
    
    private init(){
        _collectionRef = Firestore.firestore().collection(kUserCollectionPath)
    }
    
    func addNewUserMaybe(uid:String, name:String?, photoUrl:String?){
        let docRef = _collectionRef.document(uid)
        docRef.getDocument{(document, error) in
            if let document = document, document.exists{
                print("Document exists, do nothing")
            }else{
                print("Document does not exist, create one")
                docRef.setData([
                    kUserName: name ?? "",
                    kUserPhotoURL: photoUrl ?? ""
                ])
            }
        }
    }
    
    func startListening(for documentId: String, changeListener: @escaping (()-> Void))->ListenerRegistration{
        let query = _collectionRef.document(documentId)
        return query.addSnapshotListener{documentSnapshot, error in
            self._latestDocument = nil
            guard let document = documentSnapshot else{
                return
            }
            guard document.data() != nil else{
                print("document was empty")
                return
            }
            self._latestDocument = document
            changeListener()
        }
    }
    func stopListening(_ listenerRegistration: ListenerRegistration?){
        listenerRegistration?.remove()
    }
    var name: String{
        if let name = _latestDocument?.get(kUserName){
            return name as! String
        }
        return ""
    }
    
    var photoUrl: String{
        if let profilephotourl = _latestDocument?.get(kUserPhotoURL){
            return profilephotourl as! String
        }
        return ""
    }
    
    func update(name: String){

        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserName: name,
        ]){err in
            if let err = err{
                print("Error updating document:\(err)")
            }else{
                print("Name successfully updated")
            }
        }
    }
    
    func updatePhotoUrl(PhotoUrl: String){

        _collectionRef.document(_latestDocument!.documentID).updateData([
            kUserPhotoURL: PhotoUrl,
        ]){err in
            if let err = err{
                print("Error updating document:\(err)")
            }else{
                print("Name successfully updated")
            }
        }
    }
    
    
}
