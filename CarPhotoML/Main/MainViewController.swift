import UIKit
import CoreML
import Vision

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var takePhoto: UIButton!
    @IBOutlet weak var selectPhoto: UIButton!
    @IBAction func takePhoto(_ sender: Any) {
        interactor?.takePhoto(view: self)
    }
    @IBAction func selectPhoto(_ sender: Any) {
        interactor?.selectPhoto(view: self)
    }
    
    var selectedImage = CIImage()
    
    //MARK: Set up VIP
    var interactor: MainInteractor?
    func setup() {
        let interactor = MainInteractor()
        self.interactor = interactor
        let presenter = MainPresenter()
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        interactor?.setupButtonStyle(button: takePhoto)
        interactor?.setupButtonStyle(button: selectPhoto)
    }
    
    //MARK: imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        imageView.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        self.dismiss(animated: true, completion: nil)

        if let ciImage = CIImage(image: imageView.image!) {
            self.selectedImage = ciImage
        }

        interactor?.recognizeImage(image: selectedImage, resultLabel: resultLabel)
    }
    
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
