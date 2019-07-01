//
//  ViewController.swift
//  ValidateTextFieldExample
//
//  Created by Udit on 28/06/19.
//  Copyright © 2019 uDemo. All rights reserved.
//

import UIKit
import ValidateTextField

class ViewController: UIViewController {

    @IBOutlet weak var textField: ValidateTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        textField.text = "Sample"
        textField.style = .dark
        textField.errorMessage = "Sample error message"
        setBackgroundTapped()
    }

    func setBackgroundTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

