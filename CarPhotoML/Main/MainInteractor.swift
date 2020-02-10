//
//  MainInteractor.swift
//  CarPhotoML
//
//  Created by Viktor Gordienko on 2/2/20.
//  Copyright © 2020 on3. All rights reserved.
//

import UIKit
import CoreML
import Vision

class MainInteractor  {
    
    var presenter = MainPresenter()
    
    func takePhoto(view: UIViewController) {
        let picker = UIImagePickerController()
        picker.delegate = view as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        picker.sourceType = .camera
        view.present(picker, animated: true, completion: nil)
    }
    
    func selectPhoto(view: UIViewController) {
        let picker = UIImagePickerController()
        picker.delegate = view as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        view.present(picker, animated: true, completion: nil)
    }
    
    func setupButtonStyle(button: UIButton) {
        presenter.setupButtonStyle(button: button)
    }
    
    func recognizeImage(image: CIImage, resultLabel: UILabel) {
        
        resultLabel.text = "анализирую фотографию..."
        
        if #available(iOS 12.0, *) {
            if let model = try? VNCoreMLModel(for: CarPhotoClassifier_6().model) {
                let request = VNCoreMLRequest(model: model, completionHandler: { (vnrequest, error) in
                    if let results = vnrequest.results as? [VNClassificationObservation] {
                        let topResult = results.first
                        DispatchQueue.main.async {
                            let confidenceRate = (topResult?.confidence)! * 100
                            let rounded = Int (confidenceRate * 100) / 100
                            resultLabel.text = "\(rounded)% it's \(topResult?.identifier ?? "Unknown")"
                        }
                    }
                })
                let handler = VNImageRequestHandler(ciImage: image)
                DispatchQueue.global(qos: .userInteractive).async {
                    do {
                        try handler.perform([request])
                    } catch {
                        print("Err :(")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
}
