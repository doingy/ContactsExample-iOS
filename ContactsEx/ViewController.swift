//
//  ViewController.swift
//  ContactsEx
//
//  Created by 杨冬青 on 2020/6/11.
//  Copyright © 2020 杨冬青. All rights reserved.
//

import UIKit
import Contacts

final class ViewController: UIViewController {
    
    var store: CNContactStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let store = CNContactStore()
        contactAuthorization(store: store)
        self.store = store
        
        let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor])
        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                print("\(contact.givenName), \(contact.familyName)")
                for number in contact.phoneNumbers {
                    print("\(number.value.stringValue)")
                }
                print("\n")
            }
        } catch {
            print("\(error)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(contactStoreDidChange(_:)), name: NSNotification.Name.CNContactStoreDidChange, object: nil)
        
    }
    
    @objc
    func contactStoreDidChange(_ notification: Notification) {
        
    }

    func contactAuthorization(store: CNContactStore) {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .denied:
            print("用户拒绝给通讯录权限")
        case .notDetermined, .restricted:
            store.requestAccess(for: .contacts) { (result, error) in
                if error != nil {
                    print("请求通讯录权限报错\(error!)")
                }
                
                print("请求通讯录结果:\(result)")
            }

        default:
            print("已有通讯录权限")
        }
    }
}
