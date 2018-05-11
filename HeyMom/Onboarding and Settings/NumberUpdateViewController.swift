//
//  NumberUpdateViewController.swift
//  HeyMom
//
//  Created by Nien Lam on 5/7/18.
//  Copyright © 2018 Line Break, LLC. All rights reserved.
//

import UIKit
import ContactsUI

private let reuseIdentifier = "NumberTableViewCell"

class NumberUpdateViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchContactsButton: UIButton!
    
    @IBOutlet weak var selectFromContactsButton: UIButton!
    
    var tableData = [CNLabeledValue<CNPhoneNumber>?]()

    var selectedRow: Int?
    
    var didGoBack: (() -> ())?
    var didGoNext: (() -> ())?
    
    // Set to true if using VC from settings view.
    var isSettingsMode = false;

    // Get global singleton object.
    let appMgr = AppManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Button styling
        selectFromContactsButton.layer.cornerRadius =  selectFromContactsButton.bounds.height / 2.0
        selectFromContactsButton.clipsToBounds = true

        // Buttons user only for onboarding flow.
        if isSettingsMode {
            backButton.isHidden = true
            nextButton.isHidden = true
            searchContactsButton.isHidden = true
            selectFromContactsButton.isHidden = false
            
            titleLabel.text = "Select Mom from your Contacts"
            
            // We have mom contact
            if let contact = appMgr.momContact {
                /* if (contact.phoneNumbers.count > 1) {
                    titleLabel.text = "We found \(contact.phoneNumbers.count) numbers for \(contact.givenName). Select which one you normally reach her at:"
                } else {
                    titleLabel.text = "\(contact.givenName) has one number that you reach her at:"
                } */
                titleLabel.text = "\(contact.givenName)'s phone number:"
            }
            
        } else {
            titleLabel.text = "To get started, select Mom from your Contacts"
            nextButton.isEnabled = false
            searchContactsButton.isHidden = false
            selectFromContactsButton.isHidden = true
        }

        // Show stored phone number
        if let phoneNumber = appMgr.momPhoneNumber {
            tableData.append(phoneNumber)
            selectedRow = 0
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func handleBackButton(_ sender: UIButton) {
        self.didGoBack?()
    }
    
    @IBAction func handleNextButton(_ sender: UIButton) {
        self.didGoNext?()
    }
    @IBAction func handleSelectFromContactsButton(_ sender: UIButton) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func handleContactsButton(_ sender: UIButton) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}


extension NumberUpdateViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        tableData.removeAll()
        selectedRow = nil
        
        for phoneNumber in contact.phoneNumbers {
            tableData.append(phoneNumber)
            selectedRow = 0
        }
        
        print(contact.givenName, contact)

        if tableData.count == 0 {
            titleLabel.text = "Sorry, no number found"
            nextButton.isEnabled = false
        } else {
            titleLabel.text = "Hey \(contact.givenName)! You reach \(contact.givenName) at"
            appMgr.momContact = contact
            appMgr.momPhoneNumber = tableData[0]
            
            if (contact.phoneNumbers.count > 1) {
                titleLabel.text = "We found \(contact.phoneNumbers.count) numbers for \(contact.givenName), select which one you normally reach her at:"
            }
            searchContactsButton.isHidden = true
            selectFromContactsButton.isHidden = false
            nextButton.isEnabled = true
        }
        
        tableView.reloadData()
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
}


extension NumberUpdateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NumberTableViewCell
        
        let phoneNumber = tableData[indexPath.row]!

        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: phoneNumber.label!)
        let number         = phoneNumber.value as CNPhoneNumber
        
        cell.categoryLabel.text  = localizedLabel
        
        let formattedNumber = number.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        
        if selectedRow == indexPath.row {
            cell.numberLabel.text    =  "\(formattedNumber)"
            cell.categoryLabel.textColor = .black
            cell.numberLabel.textColor = .black
        } else {
            cell.numberLabel.text    =  "\(formattedNumber)"
            cell.categoryLabel.textColor = UIColor.white.withAlphaComponent(0.25)
            cell.numberLabel.textColor = UIColor.white.withAlphaComponent(0.25)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        
        appMgr.momPhoneNumber = tableData[indexPath.row]
        
        tableView.reloadData()
    }
}

