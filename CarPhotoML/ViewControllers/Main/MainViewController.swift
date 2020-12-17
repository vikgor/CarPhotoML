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
    
    private var didSetupConstraints = false
    
    private let contentView = UIView()
    
    private let carPhotoView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let takePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringValues.takePhotoButtonLabel, for: .normal)
        return button
    }()
    
    private let pickPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringValues.pickPhotoButtonLabel, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.subscribe(self)
        
        takePhotoButton.addTarget(self, action: #selector(didTapTakeButton), for: .touchUpInside)
        pickPhotoButton.addTarget(self, action: #selector(didTapPickButton), for: .touchUpInside)
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsets.zero)
            }
            
            carPhotoView.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.topMargin).inset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
                make.height.equalTo(carPhotoView.snp.width).multipliedBy(1.0/1.0)
            }
            
            resultLabel.snp.makeConstraints { make in
                make.top.equalTo(carPhotoView.snp.bottom).offset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
            }
            
            takePhotoButton.snp.makeConstraints { make in
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
                make.height.equalTo(50)
            }
            
            pickPhotoButton.snp.makeConstraints { make in
                make.top.equalTo(takePhotoButton.snp.bottom).offset(20)
                make.leading.equalTo(contentView).inset(20)
                make.trailing.equalTo(contentView).inset(20)
                make.bottom.equalTo(contentView.snp.bottom).inset(20)
                make.height.equalTo(50)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}

// MARK: - StoreSubscriber
extension MainViewController: StoreSubscriber {
    func newState(state: AppState) {
        title = state.viewTitle.rawValue
        resultLabel.text = state.resultText.rawValue
        
        switch state.photoPickerState {
        case .camera:
            openPhotoPicker(view: self, sourceType: .camera)
        case .photoLibrary:
            openPhotoPicker(view: self, sourceType: .photoLibrary)
        case .none:
            setupSubviews()
            setupNavigation()
            setupStyles()
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
    func setupSubviews() {
        view.addSubview(contentView)
        
        contentView.addSubview(carPhotoView)
        contentView.addSubview(resultLabel)
        contentView.addSubview(takePhotoButton)
        contentView.addSubview(pickPhotoButton)
        
        view.setNeedsUpdateConstraints()
    }
    
    func setupNavigation() {
        let infoButton = UIBarButtonItem(title: StringValues.infoViewTitle,
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapInfoButton))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    func setupStyles() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
        } else {
            view.backgroundColor = .lightGray
        }
        
        carPhotoView.contentMode = .scaleAspectFit
        carPhotoView.backgroundColor = .darkGray
        carPhotoView.layer.cornerRadius = 10.0
        
        resultLabel.textAlignment = .center
        [takePhotoButton, pickPhotoButton].forEach {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 10
            if #available(iOS 13.0, *) {
                $0.backgroundColor = .opaqueSeparator
                $0.setTitleColor(.label, for: .normal)
            } else {
                $0.backgroundColor = .darkGray
                $0.setTitleColor(.white, for: .normal)
            }
        }
        
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
        resultLabel.text = StringValues.analyzingLabel
        guard let model = try? VNCoreMLModel(for: CarPhoto(configuration: MLModelConfiguration()).model) else {
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
    func didTapInfoButton() {
        let viewController = InfoViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    func didTapTakeButton(sender: AnyObject) {
        mainStore.dispatch(TakePhoto())
    }
    
    @objc
    func didTapPickButton(sender: AnyObject) {
        mainStore.dispatch(PickPhoto())
    }
    
}
