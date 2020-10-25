//
//  TodayPicDataSource.swift
//  mycloud
//
//  Created by Jijo Pulikkottil on 29/09/20.
//  Copyright © 2020 MVoc. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

struct TodayPhoto {
    let briefDescription: String
    let photo: CKAsset?
    
    init?(_ record: CKRecord) {
        guard let desc = record["briefDescription"] as? String else {
            return nil
        }
        self.briefDescription = desc
        self.photo = record["photo"] as? CKAsset
    }
}

class TodayPicDataSource {
    
    let container: CKContainer
    let publicDB: CKDatabase
    
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
    }
    
    func fetchUser() {
        

        container.requestApplicationPermission(.userDiscoverability) { [weak self] (status, error) in
            print("status = \(status.rawValue)")
            
            self?.container.fetchUserRecordID { [weak self] (recordid, error) in
                if let error = error {
                    print("user id fetch err = \(error.localizedDescription)")
                }
                if let recordId = recordid {
                    self?.container.discoverUserIdentity(withUserRecordID: recordId) { [weak self] (identity, error) in
                        print("discoverUserIdentity err = \(error?.localizedDescription)")
                        print("identity?.nameComponents?.familyName = \(identity?.nameComponents?.familyName)")
                    }
                } else {
                    print("status no id")
                }
            }
            
        }
        
        
    }
    
    func getUser() {
        
        CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
            
            self.container.fetchUserRecordID { (id, err) in
                if let error = err {
                    print("user error = \(error.localizedDescription)")
                    // Failed to get record ID
                } else {
                    print("user Success")
                    // Success – fetch the user’s record here
                    self.container.discoverUserIdentity(withUserRecordID: id!) { (identity, error) in
                        if let error = err {
                            print("identity error = \(error.localizedDescription)")
                            // Failed to get record ID
                        } else if let user = identity {
                            print("user givenName" + (user.nameComponents?.givenName)!)
                        } else {
                            print("identity = \(identity)")
                        }
                    }
                }
            }
        }
        
        
    }

    func save(description: String, photoURL: URL?) {
        
        let record = CKRecord(recordType: "TodayPhoto")
        record.setValue(description, forKey: "briefDescription")
        if let picURL = photoURL {
            record.setValue(CKAsset(fileURL: picURL), forKey: "photo")
        }
        publicDB.save(record) { (_, error) in
            if let error = error {
                print("save error = \(error.localizedDescription)")
            }
        }
    }

}
