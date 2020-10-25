//
//  ViewController.swift
//  mycloud
//
//  Created by Jijo Pulikkottil on 29/09/20.
//  Copyright © 2020 MVoc. All rights reserved.
//

import UIKit
import CloudKit

//Ref: https://learnappmaking.com/icloud-key-value-store-nsubiquitouskeyvaluestore-swift/

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    let key = "planet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let f = FileManager.default.ubiquityIdentityToken
        print("token = \(String(describing: f))")
        
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("error = \(error.localizedDescription)")
            }
            print("status = \(status.rawValue)")
        }
        
        textField.text = NSUbiquitousKeyValueStore.default.string(forKey: key)
        
        NotificationCenter.default.addObserver(self, selector: #selector(storeChangeNotification(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
    }


    @IBAction func setValueToCloud() {
        textField.resignFirstResponder()
        NSUbiquitousKeyValueStore.default.set(textField.text, forKey: key)
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    @objc
    func storeChangeNotification(notification: Notification) {
        
        print("got notification")
        let changedKey = notification.userInfo?[NSUbiquitousKeyValueStoreChangedKeysKey]
        guard let cKey = (changedKey as? [String])?.first else { return }


        textField.text = NSUbiquitousKeyValueStore.default.string(forKey: cKey)
    }
}

