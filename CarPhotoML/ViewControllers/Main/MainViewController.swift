//
//  MainViewController.swift
//  CarPhotoML
//
//  Created by Viktor Gordienko on 12/10/20.
//

import UIKit
import ReSwift
import CoreML
import Vision

final class MainViewController: UIViewController {
    
    typealias StoreSubscriberStateType = AppState
    
    @IBOutlet private weak var carPhotoView: UIImageView!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var takePhotoButton: UIButton!
    @IBOutlet private weak var pickPhotoButton: UIButton!
    
    // MARK: - IBActions
    @IBAction private func takePhoto(_ sender: Any) {
        mainStore.dispatch(TakePhoto())
    }
    @IBAction private func selectPhoto(_ sender: Any) {
        mainStore.dispatch(PickPhoto())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.subscribe(self)
    }
    
}

// MARK: - StoreSubscriber
extension MainViewController: StoreSubscriber {
    func newState(state: AppState) {
        navigationItem.title = state.viewTitle.rawValue
        resultLabel.text = state.resultText.rawValue
        
        switch state.photoPickerState {
        case .camera:
            openPhotoPicker(view: self, sourceType: .camera)
        case .photoLibrary:
            openPhotoPicker(view: self, sourceType: .photoLibrary)
        case .none:
            _ = [takePhotoButton, pickPhotoButton].map { setupButtonStyle(button: $0) }
            setupNavigation()
            setupBasicStyle()
        }
        
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        carPhotoView.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        self.dismiss(animated: true, completion: nil)
        guard
            let image = carPhotoView.image,
            let ciImage = CIImage(image: image) else {
            return
        }
        analyzeImage(ciImage)
    }
    
    // Helper functions inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

// MARK: - Private
private extension MainViewController {
    func setupNavigation() {
        let infoButton = UIBarButtonItem(title: "Info",
                                         style: .plain,
                                         target: self,
                                         action: #selector(infoButtonClicked))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    func setupBasicStyle() {
        carPhotoView.layer.cornerRadius = 10.0
    }

    func setupButtonStyle(button: UIButton) {
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 10.0
    }
    
    func openPhotoPicker(view: UIViewController, sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = view as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        picker.sourceType = sourceType
        view.present(picker, animated: true, completion: nil)
    }
    
    /// Analyze the image using CoreML model and predict wheter it's good or bad
    func analyzeImage(_ image: CIImage) {
        resultLabel.text = "analyzing..."
        guard let model = try? VNCoreMLModel(for: CarPhotoClassifier_6(configuration: MLModelConfiguration()).model) else {
            return
        }
        let request = VNCoreMLRequest(model: model, completionHandler: { (vnrequest, error) in
            guard let results = vnrequest.results as? [VNClassificationObservation] else {
                return
            }
            guard let topResult = results.first else {
                return
            }
            DispatchQueue.main.async {
                let confidenceRate = (topResult.confidence) * 100
                let rounded = Int (confidenceRate * 100) / 100
                self.resultLabel.text = "\(rounded)% it's \(topResult.identifier)"
            }
            
        })
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error :(")
            }
        }
    }
    
    @objc
    func infoButtonClicked() {
        let viewController = InfoViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
