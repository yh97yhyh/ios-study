//
//  SignUpExtraViewController.swift
//  SignUp
//
//  Created by MZ01-KYONGH on 2022/01/11.
//

import UIKit

class SignUpExtraViewController: UIViewController {
    
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didDatePickerValueChanged(_ sender: UIDatePicker) {
        let date = datePicker.date
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
    }
    
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        UserInformation.user.destroy()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func touchUpPreButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchUpSignUpButton(_ sender: UIButton) {
        UserInformation.user.phoneNum = phoneNumTextField.text
        UserInformation.user.birthday = dateLabel.text
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
