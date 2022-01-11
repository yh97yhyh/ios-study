//
//  SignUpViewController.swift
//  SignUp
//
//  Created by MZ01-KYONGH on 2022/01/11.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTapImageView()
        imagePicker.allowsEditing = true

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        } else if let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpNextButton(_ sender: UIButton) {
        if passwordTextField.text == checkPasswordTextField.text {
            UserInformation.user.id = idTextField.text
            UserInformation.user.password = passwordTextField.text
            UserInformation.user.profile = textView.text
            
            performSegue(withIdentifier: "startToSignUpExtra", sender: sender)
        }
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        UserInformation.user.destroy()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initTapImageView() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(tapImageView(_ :)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func tapImageView(_ sender: UIImageView) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let signUpExtraViewController = segue.destination as? SignUpExtraViewController else { return }
//
//    }


}
