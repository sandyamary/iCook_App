//
//  LogInViewController.swift
//  iCook
//
//  Created by Udumala, Mary on 7/14/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LogInViewController: UIViewController {
    var dict : [String : AnyObject]!
    var socialId = String()
    var socialName = String()
    var socialMail = String()
    var socialImgUrlStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "iCook"
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func faceBookBTNTap(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    self.socialName = self.dict["name"] as! String
                    if self.dict["email"] != nil
                    {
                        self.socialMail = self.dict["email"] as! String
                    }
                    self.socialId = self.dict["id"] as! String
                    self.socialImgUrlStr = ((self.dict["picture"] as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as! String
                    
                    icookAddFBID(FBID:self.socialId)
                    
                    let vc = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            })
        }
    }

}
