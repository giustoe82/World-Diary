//
//  CameraVC.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-16.
//  Copyright © 2019 marcog. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import CoreML

//UINavigationControllerDelegate

class CameraVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var clickButtonOutlet: UIButton!
    @IBOutlet weak var previewImgView: UIImageView!
    
    var avSession = AVCaptureSession()
    var previousPixelBuffer:CVImageBuffer?
    var moved = false
    let newMotion = Motion()
    
    var presenter: CameraPresenterProtocol?
    //var imagePicker: UIImagePickerController!
    
    let mlModel = DiaryScan()
    
    var photoOutputFront = AVCapturePhotoOutput()
    
    var delegate: FrameExtractorDelegate?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSession()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.avSession.stopRunning()
    }
    
  
    
//    @IBAction func clickAction(_ sender: Any) {
//        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        photoOutputFront.capturePhoto(with: settings, delegate: self)
//
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
        let previewLayer = AVCaptureVideoPreviewLayer(session: avSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.frame
        cameraView.layer.addSublayer(previewLayer)
        avSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            
            func imageTranslation(request: VNRequest, error: Error?) {
                guard let result = request.results?.first as? VNImageTranslationAlignmentObservation else { return }
                let move = result.alignmentTransform
                let dist = sqrt(move.tx*move.tx + move.ty*move.ty)
                //print(dist)
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
        DispatchQueue.main.async { [unowned self] in
            guard let uiImage = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
            self.delegate?.captured(image: uiImage)
        }
        
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    func detectCoreML(pixelBuffer:CVImageBuffer) {
        func completion(request: VNRequest, error: Error?) {
            guard let observe = request.results as? [VNClassificationObservation] else { return }
            for classification in observe {
                if classification.confidence > 0.01 {
                    print(classification.identifier, classification.confidence)
                }
                
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
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        self.photoOutputFront.capturePhoto(with: settings, delegate: self)
        print(objectLabel.text as Any)
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        previewImgView.image = image
    }
    
}

protocol FrameExtractorDelegate {
    func captured(image: UIImage)
}



