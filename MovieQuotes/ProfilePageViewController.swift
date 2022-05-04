//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by Yujie Zhang on 4/29/22.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController{

    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    var userListenerRegistration: ListenerRegistration?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userListenerRegistration = UserDocumentManager.shared.startListening(for: AuthManager.shared.currentUser!.uid){
            self.updateView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDocumentManager.shared.stopListening(userListenerRegistration)
    }
    
    
    @IBAction func displayNameDidChange(_ sender: Any) {
//        print("TODO: Update name to \(displayNameTextField.text)")
        UserDocumentManager.shared.update(name: displayNameTextField!.text!)
    }
    
    @IBAction func pressedChangePhoto(_ sender: Any) {
        print("TODO: change photo")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
    
    
    func updateView(){
        displayNameTextField.text = UserDocumentManager.shared.name
        if !UserDocumentManager.shared.photoUrl.isEmpty {
            ImageUtils.load(imageView: profilePhotoImageView, from: UserDocumentManager.shared.photoUrl)
        }
    }
}

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
            profilePhotoImageView.image = image // Quick test
            StorageManager.shared.uploadProfilePhoto(uid: AuthManager.shared.currentUser!.uid, image: image)
        }
        picker.dismiss(animated: true)
    }
}
