//
//  SignLoginVC.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/6.
//

import UIKit

class SignLoginVC: UIViewController {
    
    @IBOutlet weak var signUpBtn:UIButton!
    
    @IBOutlet weak var loginBtn:UIButton!
    
    @IBOutlet weak var label:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        // Do any additional setup after loading the view.
    }
    

    private func UIInit(){
        signUpBtn.layer.borderWidth = 1
        signUpBtn.layer.borderColor = #colorLiteral(red: 0.7647058964, green: 0.7647058964, blue: 0.7647058964, alpha: 1)
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10
        let attributes = [NSAttributedString.Key.font:label.font,NSAttributedString.Key.paragraphStyle: paraph]
        label.attributedText = NSAttributedString(string: label.text ?? "", attributes: attributes as [NSAttributedString.Key : Any])
        label.textAlignment = .center
    }
    
    @IBAction func LoginBtnAction(_ sender:UIButton) {
        self.dismiss(animated: false) {
            if let VC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as? LoginVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }
    
    @IBAction func SignUpBtnAction(_ sender:UIButton) {
        self.dismiss(animated: false) {
            if let VC = UIStoryboard(name: "Sign", bundle: nil).instantiateViewController(withIdentifier: "Sign") as? SignVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }
    
    @IBAction func forgetPasswordBtnAction(_ sender:UIButton) {
        self.dismiss(animated: false) {
            if let VC = UIStoryboard(name: "ForgetPassword", bundle: nil).instantiateViewController(withIdentifier: "ForgetPassword") as? ForgetPasswordVC, let topVC = getTopController() {
                VC.modalPresentationStyle = .fullScreen
                topVC.present(VC, animated: true)
            }
        }
    }

}
