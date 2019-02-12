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

//UINavigationControllerDelegate

class CameraVC: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var scanView: UIView!
   
    @IBOutlet weak var objectLabel: UILabel!
    
    var avSession = AVCaptureSession()
    var previousPixelBuffer:CVImageBuffer?
    var moved = false
    let newMotion = Motion()
    
    var presenter: CameraPresenterProtocol?
    var imagePicker: UIImagePickerController!
    
    let mlModel = DiaryScan()
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSession()
        
        subLayeras()
        
    }
    
//    override func viewDidLayoutSubviews() {
//        subLayeras()
//    }
    
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
            
            avSession.sessionPreset = AVCaptureSession.Preset.high
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

        avSession.startRunning()
    }
    
    func subLayeras(){
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: avSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.frame
        cameraView.layer.addSublayer(previewLayer)
        
    }
    
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                    
                func imageTranslation(request: VNRequest, error: Error?) {
                        guard let result = request.results?.first as? VNImageTranslationAlignmentObservation else { return }
                        let move = result.alignmentTransform
                        let dist = sqrt(move.tx*move.tx + move.ty*move.ty)
                        //                    print(dist)
                        if dist < 10 {
                            if moved { detectCoreML(pixelBuffer: pixelBuffer) }
                            moved = false
                        } else {
                            moved = true
                        }
                    }
            
            if let previousPixelBuffer = previousPixelBuffer {
                let transRequest = VNTranslationalImageRegistrationRequest(targetedCVPixelBuffer: previousPixelBuffer, completionHandler: imageTranslation)
                let vnImage = VNSequenceRequestHandler()
                try? vnImage.perform([transRequest], on: pixelBuffer)
            }
            
            previousPixelBuffer = pixelBuffer
            
        }
    
    }
    
    
    func detectCoreML(pixelBuffer:CVImageBuffer) {
        func completion(request: VNRequest, error: Error?) {
            guard let observe = request.results as? [VNClassificationObservation] else { return }
            for classification in observe {
                if classification.confidence > 0.01 { print(classification.identifier, classification.confidence) }
              
                if let topResult = observe.first {
                    DispatchQueue.main.async {
                self.objectLabel.text = topResult.identifier + String(format: ", %.2f", topResult.confidence)
           
                    }
                }
            }
        }
    
        do {
            let model = try VNCoreMLModel(for: mlModel.model)
            let request = VNCoreMLRequest(model: model, completionHandler: completion)
            request.imageCropAndScaleOption = .centerCrop
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            // let handler = VNImageTranslationAlignmentObservation.
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func detectQR(pixelBuffer:CVImageBuffer) {
        func compHandler(request: VNRequest, error: Error?) {
            if let observe = request.results?.first as? VNBarcodeObservation {
                //                    print(observe.payloadStringValue)
                DispatchQueue.main.async {
                    self.objectLabel.text = observe.payloadStringValue
                }
            }
        }
        
        let detectReq = VNDetectBarcodesRequest(completionHandler: compHandler)
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        detectReq.symbologies = [VNBarcodeSymbology.QR, VNBarcodeSymbology.Code39, VNBarcodeSymbology.EAN13]
        //            detectReq.symbologies = [VNBarcodeSymbology.EAN13]
        try? requestHandler.perform([detectReq])
    }
    
    
    
         @IBAction func takePic(_ sender: UIButton) {

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
