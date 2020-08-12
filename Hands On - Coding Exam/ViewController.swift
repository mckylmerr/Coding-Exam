//
//  ViewController.swift
//  Hands On - Coding Exam
//
//  Created by Mc kylmerr Ico on 11/08/2020.
//  Copyright © 2020 Mc kylmerr Ico. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtMidInitial: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmailAdd: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtBirthDate: UITextField!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    let datePicker = UIDatePicker()
    var birthdate = ""
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMidInitial.delegate = self
        createDatePicker()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = txtMidInitial.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        return updateText.count < 4
        
    }
    func  createDatePicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        txtBirthDate.inputAccessoryView = toolbar
        
        txtBirthDate.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
            
        txtBirthDate.text = formatter.string(from: datePicker.date)
        birthdate = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func btnMalePressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            btnFemale.isSelected = false
        }
        else{
            sender.isSelected = true
            btnFemale.isSelected = false
            gender = "Male"
            print(gender)
        }
    }
    @IBAction func btnFemalePressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            btnMale.isSelected = false
        }
        else{
            sender.isSelected = true
            btnMale.isSelected = false
            gender = "Female"
            print(gender)
        }
    }
    
    @IBAction func btnCreate(_ sender: Any) {
        
        
        let parameters = ["firstname": "\(txtFirstName.text!)", "middlename":"\(txtMidInitial.text!)", "lastname":"\(txtLastName.text!)","emailaddress":"\(txtEmailAdd.text!)","mobilenumber":"\(txtMobileNumber.text!)","birthdate":"\(birthdate)","gender":"\(gender)"]
        
        guard let url = URL(string: "https://my-json-server.typicode.com/typicode/demo/posts") else {
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, erorr) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch{
                    print(error)
                }
            }
        }.resume()
        
        guard let firstname = txtFirstName.text, txtFirstName.text?.characters.count != 0 else {
            let mbox = UIAlertController(title: "Please enter your First Name", message: "", preferredStyle: UIAlertController.Style.alert)
            mbox.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(mbox,animated: true, completion: nil)
            return
        }
        guard let lastname = txtLastName.text, txtLastName.text?.characters.count != 0 else {
            let mbox = UIAlertController(title: "Please enter your Last Name", message: "", preferredStyle: UIAlertController.Style.alert)
            mbox.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(mbox,animated: true, completion: nil)
            return
        }
        
       
    
    }

}

