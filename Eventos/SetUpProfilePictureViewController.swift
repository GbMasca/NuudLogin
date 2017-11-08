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


class SetUpProfilePictureViewController: UIViewController, FusumaDelegate {
    
    //MARK: - Declare Variables and inicializate View
    
    @IBOutlet weak var chosenPictureButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    private var imagePicker : UIImagePickerController!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    @IBOutlet weak var viewToBeTapped: UIView!
    @IBOutlet weak var heigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var changePicButton: UIButton!
    
    @IBOutlet weak var ImageheigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ImageXConstraint: NSLayoutConstraint!
    @IBOutlet weak var ImageYConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heigthConstraint.constant = 0
        backgroundView.isHidden = true
        takePicButton.addTopBorderWithColor(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2), width: 0.5)
        photoLibraryButton.addTopBorderWithColor(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2), width: 0.5)
        initialPic()
        
        ImageXConstraint.constant = self.view.frame.size.width/2 - 88
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Read and download and store URL
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
    
    func initialPic(){
        let userID = Auth.auth().currentUser?.uid
        let userDB = Database.database().reference().child("Users").child(userID!)
        var picUrl : String = ""
        
        userDB.observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as! Dictionary<String,String>
            picUrl = data["Photo"]!
            if picUrl != ""{
                self.getPic(picUrl: picUrl)
            }
        }
    }
    
    func getPic(picUrl: String){
        let url = URL(string: picUrl)
        downloadImage(url: url!)
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)}.resume()
    }
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else {
                return }
            DispatchQueue.main.async() {
                self.makeButtonInitial(image: UIImage(data: data)!)
            }
        }
    }

    
    //MARK: - Animation and Layout changes
    
    func prepareForAnimation(){
        ImageXConstraint.constant = 0
        ImageYConstraint.constant = 30
        ImageWidthConstraint.constant = self.view.frame.size.width
        ImageheigthConstraint.constant = self.view.frame.size.width
        chosenPictureButton.layer.cornerRadius = self.view.frame.size.width/2
        chosenPictureButton.layer.masksToBounds = true
    }
    
    func hide(){
        self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.heigthConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    func unhide(){
        self.backgroundView.isHidden = false
        self.backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.heigthConstraint.constant = 236
        self.view.layoutIfNeeded()
        
    }
    
    func animateImage(){
        ImageXConstraint.constant = self.view.frame.size.width - 88
        ImageYConstraint.constant = 184
        ImageWidthConstraint.constant = 176
        ImageheigthConstraint.constant = 176
        chosenPictureButton.layer.cornerRadius = ImageheigthConstraint.constant/2
        chosenPictureButton.layer.masksToBounds = true
    }
    
    //MARK: - Button and image related
    
    func makeButton(image: UIImage){
        self.chosenPictureButton.setBackgroundImage(image, for: .normal)
        UIView.animate(withDuration: 0.4) {
            self.updateButton()
            self.view.layoutIfNeeded()
        }
    }
    func makeButtonInitial(image: UIImage){
        self.chosenPictureButton.setBackgroundImage(image, for: .normal)
        self.chosenPictureButton.layer.cornerRadius = 88
        self.chosenPictureButton.layer.masksToBounds = true
        UIView.animate(withDuration: 0.4) {
            self.updateButton()
            self.view.layoutIfNeeded()
        }
    }
    func updateButton(){
        if chosenPictureButton.currentBackgroundImage != nil{
            let color = UIColor(red: 57, green: 222, blue: 191)
            skipButton.setTitle("CONTINUAR", for: .normal)
            skipButton.setTitleColor(color, for: .normal)
            changePicButton.setTitle("ALTERAR FOTO", for: .normal)
        }
    }
    func resetButton(){
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        skipButton.setTitle("PULAR", for: .normal)
        skipButton.setTitleColor(color, for: .normal)
        changePicButton.setTitle("ADICIONAR FOTO", for: .normal)
        chosenPictureButton.setBackgroundImage(UIImage(named: "Default Image") , for: .normal)
    }
    
    //MARK: - Fusama Picker view related
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        makeButton(image: image)
    }
    func fusumaClosed() {
        print("6789")
        animateImage()
        
    }
    func fusumaWillClosed() {
        print("12345")
        animateImage()
    }
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        UIView.animate(withDuration: 1) {
            self.animateImage()
            self.view.layoutIfNeeded()
        }
        
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
    }
    
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
    
    
    func fusumaCameraRollUnauthorized() {
    }
    
    //MARK: - Button action
    
    @IBAction func changePictureFrom(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.unhide()
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        if skipButton.currentTitle == "CONTINUAR"{
            addToDB()
            performSegue(withIdentifier: "comFoto", sender: self)
        }
        if skipButton.currentTitle == "PULAR"{
            print("CARINHA NAO QUIS FOTO")
            performSegue(withIdentifier: "semFoto", sender: self)
        }
    }
    
    @IBAction func removePic(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.hide()
            self.view.layoutIfNeeded()
        }) { (canHide) in
            if canHide{
                self.backgroundView.isHidden = true
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.resetButton()
            self.view.layoutIfNeeded()
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
        self.present(fusuma, animated: true, completion: {self.prepareForAnimation()})
    }
    
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
        self.present(fusuma, animated: true, completion: {self.prepareForAnimation()})
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
}

//MARK: - DONE

extension UIButton {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
}
