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
import CoreGraphics
import Toast_Swift
import Moya

protocol PloggingDisplayLogic: AnyObject {
    // 플로깅 관련 메소드
    func displayStartPlogging()
    func displayPausePlogging()
    func displayResumePlogging()
    func displayStopPlogging()
    
    // 위치 권한 관련 메소드
    func displaySetting(message: String, url: URL)
    func displayLocation(location: CLLocationCoordinate2D)
    func displayUpdatePloggingLocation(viewModel: Plogging.UpdatePloggingLocation.ViewModel)
    func displayLocationToast()
    
    // 쓰레기통 추가 관련 메소드
    func displayFetchTrashCan(viewModel: Plogging.FetchTrashCan.ViewModel)
    func displayAddTrashCan(viewModel: Plogging.AddTrashCan.ViewModel)
    func displayAddConfirmTrashCan(viewModel: Plogging.AddConfirmTrashCan.ViewModel)
    func displayAddTrashCanCancel()
    func displayRemoveTrashCan(viewModel: Plogging.RemoveTrashCan.ViewModel)
    
    // 에러 처리
    func displayError(error: Common.CommonError, useCase: Plogging.UseCase)
}

class PloggingViewController: UIViewController {
    var interactor: PloggingBusinessLogic?
    var router: (NSObjectProtocol & PloggingRoutingLogic & PloggingDataPassing)?
    
    var ploggingState: Plogging.State = .stop
    
    var infoList: [String] = [
        "준비물을 확인해주세요",
        "퀘스트는 확인하셨나요?",
        "오늘 챌린지는 몇등이에요?",
        "환경을 지키며 운동도 한다",
        "+를 눌러 휴지통을 추가해요!",
        "핀을 눌러 휴지통을 없애요"
    ]
    
    var completedQuestIds = [Int]()
    
    var tempTrashcanAnnotation: TempTrashAnnotation?
    var minutes = 0
    var seconds = 0
    
    var timer: Timer?
    
    var annotations: [TrashcanAnnotation] = []
    
    let startBottomContainerView = UIView().then{
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 22
        $0.layer.masksToBounds = true
        $0.backgroundColor = .mainBackgroundColor
    }
    
    let doingPauseBottomContainerView = UIView().then{
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 22
        $0.layer.masksToBounds = true
        $0.backgroundColor = .mainBackgroundColor
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
        $0.text = "0.00 km"
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
    }
    
    let ploggerImageView = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "ic_plogger.png")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var startButton = UIButton().then{
        $0.setTitle("플로깅 시작하기", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
        $0.backgroundColor = .buttonEnabled
        $0.layer.cornerRadius = 28
        $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    lazy var pauseButton = UIButton().then{
        $0.setTitle("잠시 멈춤", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
        $0.backgroundColor = .buttonEnabled
        $0.layer.cornerRadius = 28
        $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)
        $0.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
    
    lazy var stopButton = UIButton().then{
        $0.setTitle("종료", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
        $0.backgroundColor = UIColor(hexString: "#FF4D35")
        $0.layer.cornerRadius = 28
        $0.layer.applySketchShadow(color: UIColor(hexString: "#FF4D35"), alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)
        $0.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    lazy var resumeButton = UIButton().then{
        $0.setTitle("이어달리기", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
        $0.backgroundColor = .buttonEnabled
        $0.layer.cornerRadius = 28
        $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)
        $0.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
    }
  
    let bubbleView = UIImageView().then{
        $0.image = UIImage(named: "bubble")
        $0.contentMode = .scaleAspectFit
    }
    
    let bubbleLabel = UILabel().then{
        $0.text = "준비물을 확인해주세요."
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var trashButton = UIButton(type: .custom).then{
        $0.setImage(UIImage(named: "ic_ploggingAddTrashcan")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(UIImage(named: "ic_ploggingAddTrashcanCancel")?.withRenderingMode(.alwaysOriginal), for: .selected)
        $0.setPreferredSymbolConfiguration(.init(scale: .default), forImageIn: .normal)
        $0.setPreferredSymbolConfiguration(.init(scale: .default), forImageIn: .selected)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
    }
    
    lazy var myLocationButton = UIButton().then{
        $0.backgroundColor = .mainBackgroundColor
        $0.setImage(UIImage(named: "ic_ploggingMyLocation")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.imageView?.contentMode = .center
        $0.tintColor = UIColor(named: "iconColor")
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
    }
    
    var myLocationBottomPriority: ConstraintMakerFinalizable? = nil
    
    lazy var mapView = MKMapView().then{
        $0.showsUserLocation = true
        $0.delegate = self
        $0.showsCompass = false
    }
    
    var trashInfoContainer = UIView().then{
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.cornerRadius = 22
        $0.layer.masksToBounds = true
        $0.backgroundColor = .mainBackgroundColor
    }
    
    var trashInfoTitleLabel = UILabel().then{
        $0.text = "이 위치에 쓰레기통을 추가 하시겠습니까?"
        $0.font = .notoSans(ofSize: 16, weight: .bold)
    }
    
    var trashInfoAddressLabel = UILabel().then{
        $0.font = .notoSans(ofSize: 12, weight: .regular)
    }
    
    var trashInfoDescriptionLabel = UILabel().then{
        $0.text = "핀을 길게 누르면 위치 수정을 할 수 있습니다."
        $0.font = .notoSans(ofSize: 12, weight: .regular)
    }
    
    lazy var addTrashCanConfirmButton = UIButton().then{
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
        $0.backgroundColor = .buttonEnabled
        $0.layer.cornerRadius = 28
        $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.3, x: 0, y: 2, blur: 10, spread: 0)
        $0.addTarget(self, action: #selector(addTrashCanConfirmButtonTapped), for: .touchUpInside)
    }
  
    lazy var coachmarkContainer = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    lazy var closeCoachmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "btn_ploggingCoachmarkClose"), for: .normal)
        $0.addTarget(self, action: #selector(closeCoachmarkButtonTapped), for: .touchUpInside)
    }
    
    // coachmark
    lazy var coachmarkDeleteTrashcanLabel = UILabel().then {
        $0.text = "꾹 눌러서 삭제 할 수 있습니다."
        $0.font = .notoSans(ofSize: 14, weight: .regular)
        $0.textColor = .white
    }
    
    lazy var coachmarkTrashcanIcon = UIImageView().then {
        $0.image = UIImage(named: "ic_pinTrashCan")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var coachmarkSmallHandIcon = UIImageView().then {
        $0.image = UIImage(named: "ic_ploggingCoachmarkHandSmall")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var coachmarkAddTrashcanIcon = UIImageView().then {
        $0.image = UIImage(named: "ic_ploggingAddTrashcan")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var coachmarkAddTrashcanLabel = UILabel().then {
        $0.text = "쓰레기통을 추가 할 수 있습니다."
        $0.font = .notoSans(ofSize: 14, weight: .regular)
        $0.textColor = .white
    }
    
    lazy var coachmarkStartButton = UIButton().then{
        $0.setTitle("플로깅 시작하기", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
        $0.backgroundColor = .buttonEnabled
        $0.layer.cornerRadius = 28
        $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.3, x: 0, y: 2, blur: 10, spread: 0)
    }
    
    lazy var coachmarkBigHandIcon = UIImageView().then {
        $0.image = UIImage(named: "ic_ploggingCoachmarkHandBig")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var coachmarkStartButtonLabel = UILabel().then {
        $0.text = "버튼을 누르면 플로깅을 시작합니다."
        $0.font = .notoSans(ofSize: 14, weight: .regular)
        $0.textColor = .white
    }
    
    
    
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
        self.interactor?.fetchTrashCan()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = self.presentedViewController as? StartCountingViewController{
            self.interactor?.startPlogging()
        }
        
        presentCompleteIfHasSuccess()
    }
    
    func presentCompleteIfHasSuccess() {
        guard !completedQuestIds.isEmpty else { return }
        let id = completedQuestIds.removeFirst()
        let popup = SuccessPopupView(frame: view.frame, questId: id)
        popup.tapHandler = { [weak self] in
            self?.presentCompleteIfHasSuccess()
            popup.removeFromSuperview()
        }
        UIApplication.shared.keyWindow?.addSubview(popup)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidCompleteQuest(_:)), name: .QuestDidComplete, object: nil)
    }
    
    @objc func onDidCompleteQuest(_ notification: Notification) {
        guard let questId = notification.userInfo?[Quest.infoKey] as? Int else { return }
        completedQuestIds.append(questId)
    }
    
    @objc func startButtonTapped(){
        self.router?.routeToStartCounting()
    }
    
    @objc func pauseButtonTapped(){
        interactor?.pausePlogging()
    }
    
    @objc func resumeButtonTapped(){
        interactor?.resumePlogging()
    }
    
    @objc func stopButtonTapped(){
        let request = Plogging.StopPlogging.Request(seconds: self.seconds, minutes: self.minutes)
        interactor?.stopPlogging(request: request)
    }
    
    @objc func trashButtonTapped(){
        if trashButton.isSelected{
            // cancelLogic
            displayAddTrashCanCancel()
        }else{
            let coordinate = mapView.centerCoordinate
            let annotation = TempTrashAnnotation(coordinate: coordinate, title: "title", subtitle: "content")
            self.tempTrashcanAnnotation = annotation
            mapView.addAnnotation(annotation)
            
            let request = Plogging.AddTrashCan.Request(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.interactor?.addTrashCan(request: request)
            
            self.trashButton.snp.remakeConstraints{
                $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
                $0.bottom.equalTo(self.trashInfoContainer.snp.top).offset(-16)
            }
        }
        
        //Todo: 핀 추가 및 이동되도록함
    }
    
    @objc func addTrashCanConfirmButtonTapped(){
        if let tempAnnotation = self.tempTrashcanAnnotation{
            let latitude = tempAnnotation.coordinate.latitude
            let longitude = tempAnnotation.coordinate.longitude
            let address = trashInfoAddressLabel.text ?? ""
            let request = Plogging.AddConfirmTrashCan.Request(latitude: latitude, longitude: longitude, address: address)
            self.interactor?.addConfirmTrashCan(request: request)
        }
    }
    
    @objc func myLocationButtonTapped(){
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    @objc func UpdateTimer() {
        seconds = seconds + 1
        if seconds == 60{
            minutes += 1
            seconds = 0
        }
        timeLabel.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        [distanceImageView, timeImageView].forEach {
            $0.tintColor = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
    }
    
    func removeTrashCan(annotation: TrashcanAnnotation){
        let alert = UIAlertController(title: "경고", message: "해당 쓰레기통을 제거하시겠습니까?", preferredStyle: .alert)
        alert.addAction(.init(title: "네", style: .default, handler: { _ in
            let id = annotation.id
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude
            
            let request = Plogging.RemoveTrashCan.Request(id: id, latitude: latitude, longitude: longitude)
            self.interactor?.removeTrashCan(request: request)
            
            
            
        }))
        alert.addAction(.init(title: "아니오", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func closeCoachmarkButtonTapped() {
        self.tabBarController?.tabBar.alpha = 1
        self.coachmarkContainer.removeFromSuperview()
        UserDefaults.standard.set(true, forDefines: .ploggingCoachmark)
    }
}

extension PloggingViewController: PloggingDisplayLogic{
    func displayFetchTrashCan(viewModel: Plogging.FetchTrashCan.ViewModel) {
        UPLoader.shared.hidden()
        for trash in viewModel.list {
            let coordinate = CLLocationCoordinate2D(
                latitude: trash.latitude,
                longitude: trash.longitude
            )
            let annotation = TrashcanAnnotation(id: trash.id, coordinate: coordinate, title: "title", subtitle: "content")
            mapView.addAnnotation(annotation)
        }
    }
    
    func displayUpdatePloggingLocation(viewModel: Plogging.UpdatePloggingLocation.ViewModel) {
        
        mapView.setRegion(viewModel.region, animated: true)
        mapView.addOverlay(viewModel.polyLine)
        
        self.distanceLabel.text = viewModel.distance
    }
    func displayStartPlogging() {
        self.startBottomContainerView.isHidden = true
        self.doingPauseBottomContainerView.isHidden = false
        self.pauseButton.isHidden = false
        self.stopButton.isHidden = true
        self.resumeButton.isHidden = true
        
        self.trashButton.snp.remakeConstraints{
            $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
            $0.bottom.equalTo(self.doingPauseBottomContainerView.snp.top).offset(-16)
        }
        self.minutes = 0
        self.seconds = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        self.ploggingState = .doing
    }
    
    func displayPausePlogging() {
        self.pauseButton.isHidden = true
        self.stopButton.isHidden = false
        self.resumeButton.isHidden = false
        self.timer?.invalidate()
        self.timer = nil
        self.ploggingState = .doing
    }
    
    func displayResumePlogging() {
        self.pauseButton.isHidden = false
        self.stopButton.isHidden = true
        self.resumeButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        self.ploggingState = .doing
    }

    @objc func displayStopPlogging() {
        self.startBottomContainerView.isHidden = false
        self.doingPauseBottomContainerView.isHidden = true
        mapView.removeOverlays(mapView.overlays)
        self.trashButton.snp.remakeConstraints{
            $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
            $0.bottom.equalTo(self.startBottomContainerView.snp.top).offset(-16)
        }
        self.timeLabel.text = "00:00"
        self.distanceLabel.text = "0.00 km"
        self.router?.routeToPloggingRecord()
        self.ploggingState = .stop
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
        let region: MKCoordinateRegion = .init(
            center: location,
            latitudinalMeters: 0.01,
            longitudinalMeters: 0.01)
        mapView.setRegion(region, animated: true)
    }
    func displayError(error: Common.CommonError, useCase: Plogging.UseCase){
        //handle error with its usecase
        UPLoader.shared.hidden()
        switch error {
        case .server(let msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case .local(let msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case .error(let error):
            if let error = error as? URLError {
                NetworkErrorManager.alert(error) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                        guard let self = self else { return }
                        switch useCase{
                        case .AddConfirmTrashCan(let request):
                            self.interactor?.addConfirmTrashCan(request: request)
                        case .FetchTrashCan:
                            self.interactor?.fetchTrashCan()
                        case .RemoveTrashCan(let request):
                            self.interactor?.removeTrashCan(request: request)
                        }
                    }
                }
            } else if let error = error as? MoyaError {
                NetworkErrorManager.alert(error)
            }
            
        }
    }
    func displayAddTrashCan(viewModel: Plogging.AddTrashCan.ViewModel) {
        UPLoader.shared.hidden()
        self.trashButton.isSelected = true
        self.trashInfoContainer.isHidden = false
        self.trashInfoAddressLabel.text = viewModel.address
    }
    
    func displayAddConfirmTrashCan(viewModel: Plogging.AddConfirmTrashCan.ViewModel) {
        UPLoader.shared.hidden()
        if let tempAnnotation = self.tempTrashcanAnnotation{
            self.mapView.removeAnnotation(tempAnnotation)
            self.trashButton.isSelected = false
            self.trashInfoContainer.isHidden = true
        }
        
        let trashcan = viewModel.trashcan
        
        let annotation = TrashcanAnnotation(id: trashcan.id, coordinate: .init(latitude: trashcan.latitude, longitude: trashcan.longitude), title: trashcan.address, subtitle: "")
        
        self.annotations.append(annotation)
        self.mapView.addAnnotation(annotation)
        
        self.trashButton.snp.remakeConstraints{
            $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
            switch self.ploggingState {
            case .stop:
                $0.bottom.equalTo(self.startBottomContainerView.snp.top).offset(-16)
            case .doing:
                $0.bottom.equalTo(self.doingPauseBottomContainerView.snp.top).offset(-16)
            }
            
        }
    }
    func displayAddTrashCanCancel() {
        self.trashButton.isSelected = false
        self.trashInfoContainer.isHidden = true
        if let annotation = self.tempTrashcanAnnotation {
            self.mapView.removeAnnotation(annotation)
            tempTrashcanAnnotation = nil
        }
        
        self.trashButton.snp.remakeConstraints{
            $0.trailing.equalTo(self.view.snp.trailing).offset(-16)
            switch self.ploggingState {
            case .stop:
                $0.bottom.equalTo(self.startBottomContainerView.snp.top).offset(-16)
            case .doing:
                $0.bottom.equalTo(self.doingPauseBottomContainerView.snp.top).offset(-16)
            }
        }
    }
    
    func displayRemoveTrashCan(viewModel: Plogging.RemoveTrashCan.ViewModel) {
        UPLoader.shared.hidden()
        if let annotation: TrashcanAnnotation = self.mapView.annotations.first(where: { (($0 as? TrashcanAnnotation)?.id ?? -1) == viewModel.trashcan.id }) as? TrashcanAnnotation{
            self.mapView.removeAnnotation(annotation)
        }
    }
    
    func displayLocationToast(){
        DispatchQueue.main.async {
            self.view.makeToast("iPhone의 '설정 > 개인 정보 보호 > 위치 서비스'에 위치 서비스 항목을 허용해주시고 다시 시도해주세요")
        }
    }
}
extension PloggingViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
            pin.image = UIImage(named: "annotation_myLocation")
            return pin
        }
        
        if annotation is TrashcanAnnotation {
            let pin = TrashAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            pin.longPressClosure = { [weak self] in
                self?.removeTrashCan(annotation: annotation as! TrashcanAnnotation)
            }
            return pin
        }else if annotation is TempTrashAnnotation {
            let pin = TempTrashAnnotationView(annotation: annotation, reuseIdentifier: "TempTrashAnnotationView")
            return pin
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MultiColorPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = polyLine.color
        renderer.lineWidth = 3
        renderer.lineJoin = .round
        renderer.lineCap = .round
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending, let annotation = view.annotation{
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude
            let request = Plogging.AddTrashCan.Request(latitude: latitude, longitude: longitude)
            self.interactor?.addTrashCan(request: request)
        }
    }
}
