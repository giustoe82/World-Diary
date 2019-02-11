//
//  CameraVC.swift
//  World Diary
//
//  Created by Aleks on 2019-02-10.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CoreML

class CameraVC: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var objectLabel: UILabel!
    
    var avSession = AVCaptureSession()
    var previousPixelBuffer:CVImageBuffer?
    var moved = false
    let newMotion = Motion()
    
    var presenter: CameraPresenterProtocol?
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSession()
    }
    
    func setUpSession() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        //                let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front)
        
        guard let captureDevice = discoverySession.devices.first else {
            print("Hittar inte kameran")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            avSession.addInput(input)
            
            avSession.sessionPreset = AVCaptureSession.Preset.low
            //            avSession.sessionPreset = AVCaptureSession.Preset.vga640x480
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.alwaysDiscardsLateVideoFrames = true
            let videoQueue = DispatchQueue(label: "objectLabel", attributes: .concurrent)
            videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
            avSession.addOutput(videoOutput)
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
            
        } catch {
            print(error)
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: avSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer.frame = cameraView.frame
        cameraView.layer.addSublayer(previewLayer)
        
        avSession.startRunning()
    }
    
//    func detectCoreML(pixelBuffer:CVImageBuffer) {
//        func completion(request: VNRequest, error: Error?) {
//            guard let observe = request.results as? [VNClassificationObservation] else { return }
//        }
//    
//        do {
//            let model = try VNCoreMLModel(for: mlModel.model)
//            let request = VNCoreMLRequest(model: model, completionHandler: completion)
//            request.imageCropAndScaleOption = .centerCrop
//            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
//            // let handler = VNImageTranslationAlignmentObservation.
//            try handler.perform([request])
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//    }
    
    
    @IBAction func takePic(_ sender: Any) {

        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                selectImageFrom(.photoLibrary)
                return
                }
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }

    //MARK: - Take image
//    @IBAction func takePhoto(_ sender: UIButton) {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            selectImageFrom(.photoLibrary)
//            return
//        }
//        selectImageFrom(.camera)
//    }
//
//    func selectImageFrom(_ source: ImageSource){
//        imagePicker =  UIImagePickerController()
//        imagePicker.delegate = self
//        switch source {
//        case .camera:
//            imagePicker.sourceType = .camera
//        case .photoLibrary:
//            imagePicker.sourceType = .photoLibrary
//        }
//        present(imagePicker, animated: true, completion: nil)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
