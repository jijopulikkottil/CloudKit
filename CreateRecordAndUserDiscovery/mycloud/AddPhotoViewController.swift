//
//  AddPhotoViewController.swift
//  mycloud
//
//  Created by Jijo Pulikkottil on 01/10/20.
//  Copyright © 2020 MVoc. All rights reserved.
//

import UIKit

class AddPhotoViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var imageURL: URL?
    let dataSource = TodayPicDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addPhotoTapped(sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func saveTapped(sender: UIButton) {
        textField.resignFirstResponder()
        guard let description = textField.text else { return }
        dataSource.save(description: description, photoURL: imageURL)
    }
}

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        print("imageURL = \(imageURL)")
    }
}
