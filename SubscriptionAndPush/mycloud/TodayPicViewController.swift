//
//  TodayPicViewController.swift
//  mycloud
//
//  Created by Jijo Pulikkottil on 29/09/20.
//  Copyright © 2020 MVoc. All rights reserved.
//

import UIKit

class TodayPicViewController: UIViewController {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let dataSource = TodayPicDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTodayPic()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPicReceived(_ :)), name: .newPicArrived, object: nil)
    
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc
    func newPicReceived(_ notification: NSNotification) {
        print("newPicReceived here")
        loadTodayPic()
    }
    
    func loadTodayPic() {
        // Do any additional setup after loading the view.
        dataSource.loadTodayPic { [weak self] (todayPhoto, error) in
            if let error = error {
                
                let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                self?.present(alertController, animated: true, completion: nil)

            } else if let todaypic = todayPhoto {
                self?.descLabel.text = todaypic.briefDescription
                let url = todaypic.photo?.fileURL
                self?.dataSource.loadImageFrom(url: url) { (image) in
                    self?.imageView.image = image
                }
            } else {
                //show no records
                self?.descLabel.text = "No Pic today"
            }
        }
    }
}

enum MyNotifications {
    static let newPicArrived = "newPicArrived"
}

extension NSNotification.Name {
    static let newPicArrived = Notification.Name(rawValue: MyNotifications.newPicArrived)
}
