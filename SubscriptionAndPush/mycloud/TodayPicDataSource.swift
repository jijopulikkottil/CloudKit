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
    
    func createSubscrption() {
        let subscription = CKQuerySubscription(recordType: "TodayPhoto", predicate: NSPredicate(value: true), options: CKQuerySubscription.Options.firesOnRecordCreation)
        
        let info = CKSubscription.NotificationInfo()
        
        info.alertLocalizationKey = "Hi, %@"
        info.alertLocalizationArgs = ["briefDescription"]
        
        
        //info.alertBody = "Hi, New Pic Available today!"
        
        subscription.notificationInfo = info
        
        publicDB.save(subscription) { (subscription, error) in
            if let error = error {
                print("Subscription error = \(error.localizedDescription)")
            }
            print("Subscription \(String(describing: subscription?.subscriptionID)) Created successfulle")
        }

    }
    
    func loadTodayPic(_ completion: @escaping (TodayPhoto?, Error?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "TodayPhoto", predicate: predicate)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        query.sortDescriptors = [sortDescriptor]
        publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID) { (results, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            guard let record = results?.first else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            let todaypic = TodayPhoto(record)
            DispatchQueue.main.async {
                completion(todaypic, nil)
            }
        }
        //
        //        let queryOperation = CKQueryOperation(query: query)
        //        queryOperation.resultsLimit = 30
        //
        //        var recordAray = [TodayPhoto]()
        //        queryOperation.recordFetchedBlock = { record in
        //            guard let todayRecord = TodayPhoto(record) else {return}
        //            recordAray.append(todayRecord)
        //        }
        //
        //        queryOperation.queryCompletionBlock
        //
        //        publicDB.add(queryOperation)
    }
    
    func loadImageFrom(url: URL?, completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            
            var image: UIImage?
            
            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            
            guard let url = url else {
                return
            }
            
            
            let imageData: Data
            do {
                imageData = try Data(contentsOf: url)
            } catch (let err) {
                //print err
                return
            }
            image = UIImage(data: imageData)
        }
        
    }
    
}
