//
//  SetUpProfilePictureViewController.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 06/11/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices

import Fusuma


class SetUpProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FusumaDelegate {
    
  
    @IBOutlet weak var chosenPictureButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    private var imagePicker : UIImagePickerController!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    @IBOutlet weak var viewToBeTapped: UIView!
    @IBOutlet weak var heigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heigthConstraint.constant = 0
        backgroundView.isHidden = true
        photoLibraryButton.addTopBorderWithColor(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2), width: 0.5)
        initialPic()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.cancelsTouchesInView = false
        viewToBeTapped.addGestureRecognizer(tap)
    }
    @objc func viewTapped(){
        UIView.animate(withDuration: 0.5, animations: {
            self.hide()
            self.view.layoutIfNeeded()
        }) { (canHide) in
            if canHide{
                self.backgroundView.isHidden = true
            }
        }
    }
    func initialPic(){
        let userID = Auth.auth().currentUser?.uid
        let userDB = Database.database().reference().child("Users").child(userID!)
        var picUrl : String = ""
        
        userDB.observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as! Dictionary<String,String>
            picUrl = data["Photo"]!
            print(data, picUrl)
            if picUrl != ""{
                
                self.getPic(picUrl: picUrl)
            }
        }
    }
    @IBAction func photoLibraryChosen(_ sender: Any){
        hide()
        backgroundView.isHidden = true
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        fusuma.cropHeightRatio = 1
        fusuma.allowMultipleSelection = false
        fusuma.defaultMode = .library
        fusumaSavesImage = true
        self.present(fusuma, animated: true, completion: nil)
    }
    
    @IBAction func dismissChoser(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.hide()
            self.view.layoutIfNeeded()
        }) { (canHide) in
            if canHide{
                self.backgroundView.isHidden = true
            }
        }
    }
    // MARK: AJdgjlsahgakdjhf
    @IBAction func takePictureChosen(_ sender: Any){
        hide()
        backgroundView.isHidden = true
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        fusuma.cropHeightRatio = 1
        fusuma.allowMultipleSelection = false
        fusuma.defaultMode = .camera
        fusumaSavesImage = true
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        makeButton(image: image)
    }
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
    }
    
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
    
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        
        guard let vc = UIApplication.shared.delegate?.window??.rootViewController,
            let presented = vc.presentedViewController else {
                
                return
        }
        
        presented.present(alert, animated: true, completion: nil)
    }
    
    func getPic(picUrl: String){
        let url = URL(string: picUrl)
        downloadImage(url: url!)
    }
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("Users")
        if let uploadData = UIImagePNGRepresentation(self.chosenPictureButton.currentBackgroundImage!) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metadata?.downloadURL()?.absoluteString)!)
                    
                }
            }
        }
    }
    func addToDB(){
        let userID = Auth.auth().currentUser?.uid
        let userDB = Database.database().reference().child("Users").child(userID!).child("Photo")
        uploadMedia() { url in
            if url != nil {
                userDB.setValue(url!)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changePictureFrom(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.unhide()
            self.view.layoutIfNeeded()
        }
        
    }
    func changePicture(from: Int){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        if from == 1{
            imagePicker.sourceType = .camera
        }
        else{
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String){
            let image = info[UIImagePickerControllerEditedImage] as! UIImage
            makeButton(image: image)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        addToDB()
    }
    
    func updateButton(){
        
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.makeButton(image: UIImage(data: data)!)
            }
        }
    }
    
    func makeButton(image: UIImage){
        
        self.chosenPictureButton.setBackgroundImage(image, for: .normal)
        self.chosenPictureButton.layer.cornerRadius = 88
        self.chosenPictureButton.layer.masksToBounds = true
        updateButton()
    }
    
    func hide(){
        self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.heigthConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    func unhide(){
        self.backgroundView.isHidden = false
        self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.heigthConstraint.constant = 181
        self.view.layoutIfNeeded()
        
    }
}
extension UIButton {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
}
extension UIImage{
    
    class func imageFromSystemBarButton(_ systemItem: UIBarButtonSystemItem, renderingMode:UIImageRenderingMode = .automatic)-> UIImage {
        
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        let bar = UIToolbar()
        bar.setItems([tempItem],animated: false)
        bar.snapshotView(afterScreenUpdates: true)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        
        for view in itemView.subviews {
            if view is UIButton {
                let button = view as! UIButton
                let image = button.imageView!.image!
                image.withRenderingMode(renderingMode)
                return image
            }
        }
        
        return UIImage()
    }
}
