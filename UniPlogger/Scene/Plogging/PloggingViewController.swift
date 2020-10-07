//
//  PloggingViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/27.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SnapKit
import Then
import MapKit

protocol PloggingDisplayLogic: class {
    func displayError(error: Common.CommonError, useCase: Plogging.UseCase)
    func displayStart()
    func displayPause()
    func displaySetting(message: String, url: URL)
    func displayLocation(location: CLLocationCoordinate2D)
}

class PloggingViewController: BaseViewController {
    var interactor: PloggingBusinessLogic?
    var router: (NSObjectProtocol & PloggingRoutingLogic & PloggingDataPassing)?
    
    var state: Plogging.State = .ready
    var minutes = 0
    var seconds = 0
    
    var timer: Timer?
    let startBottomContainerView = GradientView().then{
        $0.isHorizontal = true
        $0.colors = [.bottomGradientStart, .bottomGradientEnd]
        $0.locations = [0.0, 1.0]
    }
    
    let doingPauseBottomContainerView = GradientView().then{
        $0.isHorizontal = true
        $0.colors = [.bottomGradientStart, .bottomGradientEnd]
        $0.locations = [0.0, 1.0]
    }
    
    let distanceContainer = UIView().then{
        $0.backgroundColor = .clear
    }
    
    let distanceImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_plogging_distance")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
    }
    
    let distanceLabel = UILabel().then{
        $0.font = .roboto(ofSize: 30, weight: .bold)
        $0.text = "0.00"
        $0.textColor = .black
    }
    
    let distanceUnitLabel = UILabel().then{
        $0.font = .roboto(ofSize: 20, weight: .bold)
        $0.text = "km"
        $0.textColor = .white
    }
    
    let timeContainer = UIView().then{
        $0.backgroundColor = .clear
    }
    
    let timeImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_plogging_time")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
    }
    
    let timeLabel = UILabel().then{
        $0.font = .roboto(ofSize: 30, weight: .bold)
        $0.text = "00:00"
        $0.textColor = .white
    }
    
    let ploggerImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "ic_plogger.png")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var startButton = UIButton().then{
        $0.setTitle("START PLOGGING!", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    lazy var pauseButton = UIButton().then{
        $0.setTitle("잠시 멈춤", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
    
    lazy var stopButton = UIButton().then{
        $0.setTitle("종료", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .init(red: 244, green: 95, blue: 95)
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(displayStop), for: .touchUpInside)
    }
    
    lazy var resumeButton = UIButton().then{
        $0.setTitle("이어달리기", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .main
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(displayResume), for: .touchUpInside)
    }
  
    let bubbleView = UIView().then{
        $0.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    let bubbleLabel = UILabel().then{
        $0.text = "준비물을 확인해주세요."
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var trashButton = UIButton().then{
        $0.setImage(UIImage(named: "ic_trashcan")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.imageView?.contentMode = .center
        $0.backgroundColor = UIColor(red: 95/255, green: 116/255, blue: 244/255, alpha: 1)
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
    }
    
    let mapView = MKMapView()
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = PloggingInteractor()
        let presenter = PloggingPresenter()
        let router = PloggingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setupView()
        setupLayout()
        
        self.interactor?.setupLocationService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationManager.shared.requestLocation()
        if let _ = self.presentedViewController as? StartCountingViewController{
            self.startPlogging()
        }
    }
    
    @objc func startButtonTapped(){
        let reqquest = Plogging.ChangeState.Request(state: self.state)
        interactor?.changeState(request: reqquest)
    }
    
    @objc func pauseButtonTapped(){
        let reqquest = Plogging.ChangeState.Request(state: self.state)
        interactor?.changeState(request: reqquest)
    }
    
    @objc func UpdateTimer() {
        seconds = seconds + 1
        if seconds == 60{
            minutes += 1
            seconds = 0
        }
        timeLabel.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
    }
  
    func startPlogging(){
        self.startBottomContainerView.isHidden = true
        self.doingPauseBottomContainerView.isHidden = false
        self.pauseButton.isHidden = false
        self.stopButton.isHidden = true
        self.resumeButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 12.0, *) {
                // User Interface is Dark
                [distanceLabel,distanceUnitLabel,timeLabel].forEach {
                    $0.textColor = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
                }
                [distanceImageView, timeImageView].forEach{
                    $0.tintColor = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
                }
        } else {
            [distanceLabel,distanceUnitLabel,timeLabel].forEach {
                $0.textColor = .black
            }
            [distanceImageView, timeImageView].forEach{
                $0.tintColor = .black
            }
        }
    }
  
}

extension PloggingViewController: PloggingDisplayLogic{
    func displayStart() {
        self.state = .doing
        self.router?.routeToStartCounting()
    }
    
    func displayPause() {
        self.pauseButton.isHidden = true
        self.stopButton.isHidden = false
        self.resumeButton.isHidden = false
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func displayStop() {
        self.seconds = 0
        self.minutes = 0
        timeLabel.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        self.startBottomContainerView.isHidden = false
        self.doingPauseBottomContainerView.isHidden = true
    }
    
    @objc func displayResume() {
        self.pauseButton.isHidden = false
        self.stopButton.isHidden = true
        self.resumeButton.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    func displaySetting(message: String, url: URL){
        let alert = UIAlertController(title: "위치 권한 필요", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "권한설정", style: .default, handler: { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func displayLocation(location: CLLocationCoordinate2D) {
        self.mapView.centerCoordinate = location
        var region: MKCoordinateRegion = self.mapView.region
        var span: MKCoordinateSpan = mapView.region.span
        span.latitudeDelta *= 0.001
        span.longitudeDelta *= 0.001
        region.span = span
        mapView.setRegion(region, animated: true)
    }
    func displayError(error: Common.CommonError, useCase: Plogging.UseCase){
        //handle error with its usecase
    }
}
