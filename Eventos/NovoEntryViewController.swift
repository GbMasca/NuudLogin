//
//  NovoLogin.swift
//  Eventos
//
//  Created by Gabriel Mascarenhas on 30/10/2017.
//  Copyright © 2017 Gabriel Mascarenhas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON


class NovoEntryViewController: UIViewController,UIScrollViewDelegate{
    
    // MARK: - Declare Instace Variables
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scView: UIScrollView!
    @IBOutlet weak var facebookButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scView.delegate = self
        scView.isPagingEnabled = true
        let windowWidth = self.view.frame.size.width
        let windowHeight = self.view.frame.size.height
        let frameSize = scView.frame.size.height
        
        scView.frame = CGRect(origin: CGPoint(x:CGFloat(0), y:(windowHeight/2 - 230)), size: CGSize(width: windowWidth, height: frameSize))
        
        scView.contentSize = CGSize(width: windowWidth * 3, height: scView.frame.size.height)
        pageControl.numberOfPages = 3
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        loadScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Scroll View Related
    
    func loadScrollView(){

        loadFirstPage()
        loadSecondPage()
        loadThirdPage()
    }
    func loadFirstPage(){
        let windowWidth = self.view.frame.size.width
        print(windowWidth)
        
        let titleText = UILabel(frame: CGRect(origin: CGPoint(x: scView.frame.width * 0, y: (55*scView.frame.height/100 - 18)), size: CGSize(width: windowWidth, height: 36)))
        titleText.text = "Ticket Eletronico"
        titleText.font = UIFont(name: "Helvetica Neue", size: CGFloat(22))
        titleText.textAlignment = NSTextAlignment.center
        self.scView.addSubview(titleText)
        
        let subTitleText1 = UILabel(frame: CGRect(origin: CGPoint(x: scView.frame.width * 0, y: (55*scView.frame.height/100 + 18)), size: CGSize(width: windowWidth, height: 20)))
        subTitleText1.text = "Sempre em suas mãos"
        subTitleText1.font = UIFont(name: "Helvetica Neue", size: CGFloat(17))
        subTitleText1.textAlignment = NSTextAlignment.center
        subTitleText1.alpha = 0.60
        self.scView.addSubview(subTitleText1)
        
        let icon = UIImageView(frame: CGRect(origin: CGPoint(x: (2*windowWidth/7), y: 0), size: CGSize(width: (3*windowWidth/7), height: (3*windowWidth/7))))
        icon.image = UIImage(named: "Ticket")
        print("Height" ,icon.frame.height)
        self.scView.addSubview(icon)
        
    }
    func loadSecondPage(){
        let windowWidth = self.view.frame.size.width
        print(windowWidth)
        
        let titleText = UILabel(frame: CGRect(origin: CGPoint(x: scView.frame.width * 1, y: (55*scView.frame.height/100 - 18)), size: CGSize(width: windowWidth, height: 36)))
        titleText.text = "Adquira em um clique"
        titleText.font = UIFont(name: "Helvetica Neue", size: CGFloat(22))
        titleText.textAlignment = NSTextAlignment.center
        self.scView.addSubview(titleText)
        
        let subTitleText1 = UILabel(frame: CGRect(origin: CGPoint(x: scView.frame.width * 1, y: (55*scView.frame.height/100 + 18)), size: CGSize(width: windowWidth, height: 20)))
        subTitleText1.text = "Uma conta só sua"
        subTitleText1.font = UIFont(name: "Helvetica Neue", size: CGFloat(17))
        subTitleText1.textAlignment = NSTextAlignment.center
        subTitleText1.alpha = 0.60
        self.scView.addSubview(subTitleText1)
        
        let subTitleText2 = UILabel(frame: CGRect(origin: CGPoint(x: scView.frame.width * 1, y: (55*scView.frame.height/100 + 38)), size: CGSize(width: windowWidth, height: 20)))
        subTitleText2.text = "Basta clicar e comprar"
        subTitleText2.font = UIFont(name: "Helvetica Neue", size: CGFloat(17))
        subTitleText2.textAlignment = NSTextAlignment.center
        subTitleText2.alpha = 0.60
        self.scView.addSubview(subTitleText2)
        
        let icon = UIImageView(frame: CGRect(origin: CGPoint(x: (9*windowWidth/7), y: 0), size: CGSize(width: (3*windowWidth/7), height: (3*windowWidth/7))))
        icon.image = UIImage(named: "Click")
        self.scView.addSubview(icon)
        
    }
    func loadThirdPage(){
        let windowWidth = self.view.frame.size.width
        
        let titleText = UILabel(frame: CGRect(origin: CGPoint(x: scView.frame.width * 2, y: (55*scView.frame.height/100 - 18)), size: CGSize(width: windowWidth, height: 36)))
        titleText.text = "Descontos Frequentes"
        titleText.font = UIFont(name: "Helvetica Neue", size: CGFloat(22))
        titleText.textAlignment = NSTextAlignment.center
        self.scView.addSubview(titleText)
        
        let subTitleText1 = UILabel(frame: CGRect(origin: CGPoint(x: scView.frame.width * 2, y: (55*scView.frame.height/100 + 18)), size: CGSize(width: windowWidth, height: 20)))
        subTitleText1.text = "Quanto mais você usa"
        subTitleText1.font = UIFont(name: "Helvetica Neue", size: CGFloat(17))
        subTitleText1.textAlignment = NSTextAlignment.center
        subTitleText1.alpha = 0.60
        self.scView.addSubview(subTitleText1)
        
        let subTitleText2 = UILabel(frame: CGRect(origin: CGPoint(x: scView.frame.width * 2, y: (55*scView.frame.height/100 + 38)), size: CGSize(width: windowWidth, height: 20)))
        subTitleText2.text = "mais você ganha"
        subTitleText2.font = UIFont(name: "Helvetica Neue", size: CGFloat(17))
        subTitleText2.textAlignment = NSTextAlignment.center
        subTitleText2.alpha = 0.60
        self.scView.addSubview(subTitleText2)
        
        let icon = UIImageView(frame: CGRect(origin: CGPoint(x: (16*windowWidth/7), y: 0), size: CGSize(width: (3*windowWidth/7), height: (3*windowWidth/7))))
        icon.image = UIImage(named: "Descontos")
        self.scView.addSubview(icon)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewWidth: CGFloat = scrollView.frame.size.width
        let pageNumber = floor((scrollView.contentOffset.x - viewWidth / 50) / viewWidth) + 1
        pageControl.currentPage = Int(pageNumber)
    }
    

    // MARK: - User Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        print("Pressed")
        performSegue(withIdentifier: "goToLoginPage", sender: self)
    }
    
    @IBAction func loginWithFacebookPressed(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if error != nil {
                    print(error!)
                }
                else{
                    print("login com FB feito")
                    self.performSegue(withIdentifier: "goToWelcomingPage", sender: self)
                    self.populateData()
                }
            })
        }
    }
    func addToDB(data: [String:String]){
        let userID = Auth.auth().currentUser?.uid
        let userDB = Database.database().reference().child("Users")
        userDB.child(userID!).setValue(data)
    }
    func populateData(){
        var name : String = ""
        var email : String  = ""
        var url : String = ""
        var userData : [String:String] = [:]
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, picture.type(large)"]).start {
            (connection, result, error) -> Void in
            if error != nil {
                NSLog(error.debugDescription)
                return
            }
            
            let result : JSON = JSON(result!)
            url = String(describing: result["picture"]["data"]["url"])
            name = String(describing: result["name"])
            email = String(describing: result["email"])
            
            userData = ["Name": name, "Email": email, "Photo": url]
            print("aaaaaaaaaa", userData)
            self.addToDB(data: userData)
        }
        
    }
}
