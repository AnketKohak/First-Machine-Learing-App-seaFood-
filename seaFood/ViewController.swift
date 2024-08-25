//
//  ViewController.swift
//  seaFood
//
//  Created by Anket Kohak on 21/08/24.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    //MARK: - load
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    //MARK: - imagepickercontroller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userClickImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userClickImage
            guard let ciimage = CIImage(image: userClickImage) else{
                fatalError("could not convert to ciimage to image")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    //MARK: - detect
    func detect(image:CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)else{
            fatalError("loading core model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("results failed")
            }
            print(results)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
    }
    //MARK: - cameraTapped
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true , completion: nil)
    }
}

