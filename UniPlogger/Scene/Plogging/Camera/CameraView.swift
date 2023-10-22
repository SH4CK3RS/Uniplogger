//
//  CameraView.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import Then
import SnapKit
import AVFoundation

enum FlashMode {
    case auto, on, off
    var image: UIImage? {
        switch self {
        case .auto: return UIImage(named: "flash_auto")
        case .on: return UIImage(named: "flash_on")
        case .off: return UIImage(named: "flash_off")
        }
    }
}

enum CameraViewAction {
    case didTakePhoto(UIImage)
}

protocol CameraViewListener: AnyObject {
    func action(_ action: CameraViewAction)
}

final class CameraView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: CameraViewListener?
    
    func configureCaptureSession() {
        guard let backCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .back
        )
        else { return }
        captureSession.beginConfiguration()
        captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
        captureSession.sessionPreset = .photo
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func stopSession() {
        captureSession.stopRunning()
    }
    
    // MARK: - Private
    private let captureSession = AVCaptureSession()
    private let stillImageOutput = AVCapturePhotoOutput()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    
    private var flashMode: FlashMode = .auto {
        didSet {
            flashButton.setImage(flashMode.image, for: .normal)
        }
    }
    
    private let finderView = UIView()
    private let captureImageView = UIImageView()
    private let cameraButton = UIButton()
    private let flashButton = UIButton()
    private let descriptionLabel = UILabel()
    
    private func setupLivePreview() {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        self.videoPreviewLayer = videoPreviewLayer
        
        finderView.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                videoPreviewLayer.frame = self.finderView.bounds
            }
        }
    }
    
    @objc
    private func cameraButtonTapped() {
        guard !captureSession.outputs.isEmpty,
              !captureSession.inputs.isEmpty else {
            
            return
        }
        stillImageOutput.capturePhoto(with: photoSetting, delegate: self)
    }
    
    @objc
    private func flashButtonTapped() {
        switch flashMode {
        case .auto: flashMode = .on
        case .on: flashMode = .off
        case .off: flashMode = .auto
        }
        setFlashMode()
    }
    
    private func setFlashMode() {
        switch flashMode {
        case .auto:
            photoSetting.flashMode = .auto
        case .off:
            photoSetting.flashMode = .off
        case .on:
            photoSetting.flashMode = .on
        }
    }
}

private extension CameraView {
    func setup() {
        backgroundColor = .black
        cameraButton.do {
            $0.setImage(UIImage(named: "share_camera"), for: .normal)
            $0.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        }
        flashButton.do {
            $0.setImage(UIImage(named: "flash_auto"), for: .normal)
            $0.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
        }
        descriptionLabel.do {
            $0.numberOfLines = 0
            $0.text = "플로깅한 쓰레기를\n촬영해주세요."
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = .notoSans(ofSize: 18, weight: .regular)
        }
        
        [finderView, captureImageView, cameraButton, flashButton, descriptionLabel].forEach {
            addSubview($0)
        }
    }
    func layout() {
        let frame = UIScreen.main.bounds
        finderView.snp.makeConstraints {
            $0.top.equalTo(frame.height * 0.211)
            $0.width.equalTo(frame.width)
            $0.height.equalTo(frame.width)
        }
        flashButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(frame.height * 0.117)
        }
        cameraButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-frame.height * 0.098)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(frame.width * 0.17)
        }
        descriptionLabel.snp.makeConstraints {
            $0.center.equalTo(finderView)
        }
    }
}

extension CameraView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData)
        else { return }
        listener?.action(.didTakePhoto(image))
    }
}
