//
//  EmailAuthVC.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 18/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class EmailAuthVC: UIViewController {

    @IBOutlet weak var inputstackLenght: NSLayoutConstraint!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var passwordTxt: MaterialTextField!
    @IBOutlet weak var phoeTxt: MaterialTextField!
    @IBOutlet weak var emailTxt: MaterialTextField!
    @IBOutlet weak var usernameTxt: MaterialTextField!
    @IBOutlet weak var authButt: MaterialButtons!
    @IBOutlet weak var formStack: CustomImageView!
    @IBOutlet weak var addPhotoButt: UIButton!
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var baseView: MaterialView!
    private var profImage:UIImage?
    var auth:AuthService = AuthService()
    lazy var imagePicker:UIImagePickerController = {
        return UIImagePickerController()
    }()
    var logType:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if logType == 100{
            phoeTxt.isHidden = true
            usernameTxt.isHidden = true
            authButt.setTitle("Log In", for: .normal)
            inputstackLenght.constant = 150
            addPhotoButt.isHidden = true
            profileImg.isHidden = true
            
        }
        usernameTxt.delegate = self
        passwordTxt.delegate = self
        emailTxt.delegate = self
        phoeTxt.delegate = self
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func dismissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addPhotoPressed(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func AuthPressed(_ sender: Any) {
        if logType == 100{
            signIn()
        }else{
            signup()
        }
    }

    
    func signIn(){
        
        let email = emailTxt.text ?? ""
        let password = passwordTxt.text ?? ""
        if password.count > 5 && email.count > 3 && email.contains("@"){
            loaderView.isHidden = false
            loader.startAnimating()
            auth.signIn(with: email, and: password) { (suc, err) in
                self.loader.stopAnimating()
                self.loaderView.isHidden = true
                if suc{
                    self.performSegue(withIdentifier: Segue.tohome.rawValue, sender: nil)
                }
            }
        }else{
           present(createDefaultAlert("ERROR", "Please make sure to enter a valid email and password ",.alert, "OK", .default,nil), animated: true, completion: nil)
        }
    }
    
    func signup(){
        let username = usernameTxt.text ?? ""
        let phone = phoeTxt.text ?? ""
        let email = emailTxt.text ?? ""
        let password = passwordTxt.text ?? ""
        if username.count > 3 && password.count > 5 && email.count > 3 && email.contains("@"){
            loader.startAnimating()
            loaderView.isHidden = false
            auth.signUp(with: email, and: password) { (success, errM) in
                if (success as Bool) == true{
                    let uid = UserDefaults.standard.string(forKey: USER_UID) ?? ""
                    let data = [Fields.username.rawValue:username, Fields.profileUrl.rawValue: "", Fields.dateCreated.rawValue:Date(),Fields.phone.rawValue:phone] as [String : Any]
                    DataService.main.setUserData(uid: uid, data: data, profiledata: self.makeImgageData(), { (suc, err) in
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        if (suc  == true){
                            
                            self.performSegue(withIdentifier: Segue.tohome.rawValue, sender: nil)
                        }else{
                            let alert = createDefaultAlert("OOPS!!", err ?? "Unknown Error",.alert, "Dismiss",.default, nil)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }else{
                  self.present(createDefaultAlert("ERROR", errM ?? "Unknown Error",.alert, "OK", .default,nil), animated: true, completion: nil)
                }
            }
        }else{
            present(createDefaultAlert("ERROR", "Please make sure to enter a valid name and a password of 5 or more characters",.alert, "OK", .default,nil), animated: true, completion: nil)
        }
    }
 

    func makeImgageData()->Data?{
        return profImage?.pngData()
    }
}


extension EmailAuthVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.profileImg.image = image
            profImage = image
        }
        if profileImg.image == nil{
            addPhotoButt.setTitle("Add Photo", for: .normal)
        }else{
           addPhotoButt.setTitle("", for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        if profileImg.image == nil{
            addPhotoButt.setTitle("Add Photo", for: .normal)
        }else{
            addPhotoButt.setTitle("", for: .normal)
        }
    }
}


extension EmailAuthVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
