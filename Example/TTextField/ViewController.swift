//
//  ViewController.swift
//  TTextField
//
//  Created by fanta1ty on 07/31/2022.
//  Copyright (c) 2022 fanta1ty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var contentView = ContentView()
    private var toggleValidation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.textField.becomeFirstResponder()
        contentView.textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func loadView() {
        view = contentView
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        toggleValidation.toggle()
        
        if toggleValidation {
            contentView.textField.errorMessage = "The e-mail address entered is incorrect"
        } else {
            contentView.textField.errorMessage = nil
        }
        
        return true
    }
}
