//
//  ViewController.swift
//  seeFood
//
//  Created by Hongbo Niu on 2018-03-28.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = userPickImage
            guard let ciimage = CIImage(image:userPickImage) else{fatalError("fail to convert uiimage to ciimage")}
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image:CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{fatalError("loading coreMlModel failed")}
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else{fatalError("model fail to process image")}
            if let firstResult = result.first{
            if firstResult.identifier.contains("hotdog"){
                self.navigationItem.title = "hotdog"
                
            }else{
                self.navigationItem.title = "not hotdog"
            }
        }
    }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        }catch{
            print("error")
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}

