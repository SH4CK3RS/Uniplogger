//
//  PloggingMainView.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

enum PloggingMainViewAction {
    case startButtonTapped
    case pauseButtonTapped
    case resumeButtonTapped
    case stopButtonTapped
    case trashButtonTapped
    case addTrashCanConfirmButtonTapped
    case myLocationButtonTapped
    case closeCoachmarkButtonTapped
    case removeTrashCan(TrashcanAnnotation)
    case addTrashCan(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

protocol PloggingMainViewListener: AnyObject {
    func action(_ action: PloggingMainViewAction)
}

final class PloggingMainView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
        setRandomBubbleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: PloggingMainViewListener?
    
    func showCoachmark() {
        coachmarkContainer.isHidden = false
    }
    
    func hideCoachmark() {
        coachmarkContainer.isHidden = true
    }
    
    // MARK: - Private
    private let infoList: [String] = [
        "준비물을 확인해주세요",
        "퀘스트는 확인하셨나요?",
        "오늘 챌린지는 몇등이에요?",
        "환경을 지키며 운동도 한다",
        "+를 눌러 휴지통을 추가해요!",
        "핀을 눌러 휴지통을 없애요"
    ]
    private var completedQuestIds = [Int]()
    
    private let startBottomContainerView = UIView()
    private let doingPauseBottomContainerView = UIView()
    private let distanceContainer = UIView()
    private let distanceImageView = UIImageView()
    private let distanceLabel = UILabel()
    private let timeContainer = UIView()
    private let timeImageView = UIImageView()
    private let timeLabel = UILabel()
    private let ploggerImageView = UIImageView()
    private let startButton = UIButton()
    private let pauseButton = UIButton()
    private let stopButton = UIButton()
    private let resumeButton = UIButton()
    private let bubbleView = UIImageView()
    private let bubbleLabel = UILabel()
    private let trashButton = UIButton(type: .custom)
    private let myLocationButton = UIButton()
    private let mapView = MKMapView()
    private let trashInfoContainer = UIView()
    private let trashInfoTitleLabel = UILabel()
    private let trashInfoAddressLabel = UILabel()
    private let trashInfoDescriptionLabel = UILabel()
    private let addTrashCanConfirmButton = UIButton()
    private let coachmarkContainer = UIView()
    private let closeCoachmarkButton = UIButton()
    
    // coachmark
    private let coachmarkDeleteTrashcanLabel = UILabel()
    private let coachmarkTrashcanIcon = UIImageView()
    private let coachmarkSmallHandIcon = UIImageView()
    private let coachmarkAddTrashcanIcon = UIImageView()
    private let coachmarkAddTrashcanLabel = UILabel()
    private let coachmarkStartButton = UIButton()
    private let coachmarkBigHandIcon = UIImageView()
    private let coachmarkStartButtonLabel = UILabel()
    
    // Constraints
    private let myLocationBottomPriority: ConstraintMakerFinalizable? = nil
    
    private func setRandomBubbleLabel(){
        let randomIndex = Int(arc4random() % 6)
        let infoText = infoList[randomIndex]
        bubbleLabel.text = infoText
    }
    
    @objc
    private func onDidCompleteQuest(_ notification: Notification) {
        guard let questId = notification.userInfo?[Quest.infoKey] as? Int else { return }
        completedQuestIds.append(questId)
    }
    
    @objc
    private func startButtonTapped(){
        listener?.action(.startButtonTapped)
    }
    
    @objc
    private func pauseButtonTapped(){
        listener?.action(.pauseButtonTapped)
    }
    
    @objc
    private func resumeButtonTapped(){
        listener?.action(.resumeButtonTapped)
    }
    
    @objc
    private func stopButtonTapped(){
        listener?.action(.stopButtonTapped)
    }
    
    @objc
    private func trashButtonTapped(){
        listener?.action(.trashButtonTapped)
    }
    
    @objc
    private func addTrashCanConfirmButtonTapped(){
        listener?.action(.addTrashCanConfirmButtonTapped)
    }
    
    @objc
    private func myLocationButtonTapped(){
        listener?.action(.myLocationButtonTapped)
    }
    
    @objc
    private func closeCoachmarkButtonTapped() {
        listener?.action(.closeCoachmarkButtonTapped)
    }
    
    func removeTrashCan(annotation: TrashcanAnnotation){
        listener?.action(.removeTrashCan(annotation))
    }
}

private extension PloggingMainView {
    func setup() {
        startBottomContainerView.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 22
            $0.layer.masksToBounds = true
            $0.backgroundColor = .mainBackgroundColor
        }
        doingPauseBottomContainerView.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 22
            $0.layer.masksToBounds = true
            $0.backgroundColor = .mainBackgroundColor
        }
        distanceContainer.backgroundColor = .clear
        distanceImageView.do {
            $0.image = UIImage(named: "ic_plogging_distance")?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
        }
        distanceLabel.do {
            $0.font = .roboto(ofSize: 30, weight: .bold)
            $0.text = "0.00 km"
        }
        timeContainer.backgroundColor = .clear
        timeImageView.do {
            $0.image = UIImage(named: "ic_plogging_time")?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
        }
        timeLabel.do {
            $0.font = .roboto(ofSize: 30, weight: .bold)
            $0.text = "00:00"
        }
        ploggerImageView.do {
            $0.image = #imageLiteral(resourceName: "ic_plogger.png")
            $0.contentMode = .scaleAspectFit
        }
        startButton.do {
            $0.setTitle("플로깅 시작하기", for: .normal)
            $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
            $0.backgroundColor = .buttonEnabled
            $0.layer.cornerRadius = 28
            $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)
            $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        }
        pauseButton.do {
            $0.setTitle("잠시 멈춤", for: .normal)
            $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
            $0.backgroundColor = .buttonEnabled
            $0.layer.cornerRadius = 28
            $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)
            $0.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        }
        stopButton.do {
            $0.setTitle("종료", for: .normal)
            $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
            $0.backgroundColor = UIColor(hexString: "#FF4D35")
            $0.layer.cornerRadius = 28
            $0.layer.applySketchShadow(color: UIColor(hexString: "#FF4D35"), alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)
            $0.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        }
        resumeButton.do {
            $0.setTitle("이어달리기", for: .normal)
            $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
            $0.backgroundColor = .buttonEnabled
            $0.layer.cornerRadius = 28
            $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)
            $0.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
        }
        bubbleView.do {
            $0.image = UIImage(named: "bubble")
            $0.contentMode = .scaleAspectFit
        }
        bubbleLabel.do {
            $0.text = "준비물을 확인해주세요."
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 14)
        }
        trashButton.do {
            $0.setImage(UIImage(named: "ic_ploggingAddTrashcan")?.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.setImage(UIImage(named: "ic_ploggingAddTrashcanCancel")?.withRenderingMode(.alwaysOriginal), for: .selected)
            $0.setPreferredSymbolConfiguration(.init(scale: .default), forImageIn: .normal)
            $0.setPreferredSymbolConfiguration(.init(scale: .default), forImageIn: .selected)
            $0.imageView?.contentMode = .scaleAspectFit
            $0.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        }
        myLocationButton.do {
            $0.backgroundColor = .mainBackgroundColor
            $0.setImage(UIImage(named: "ic_ploggingMyLocation")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.imageView?.contentMode = .center
            $0.tintColor = UIColor(named: "iconColor")
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
        }
        mapView.do {
            $0.showsUserLocation = true
            $0.delegate = self
            $0.showsCompass = false
            $0.register(
            TrashAnnotationView.self,
            forAnnotationViewWithReuseIdentifier:
              MKMapViewDefaultAnnotationViewReuseIdentifier)
            $0.register(
            TempTrashAnnotationView.self,
            forAnnotationViewWithReuseIdentifier:
              "TempTrashAnnotationView")
        }
        trashInfoContainer.do {
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 22
            $0.layer.masksToBounds = true
            $0.backgroundColor = .mainBackgroundColor
        }
        trashInfoTitleLabel.do {
            $0.text = "이 위치에 쓰레기통을 추가 하시겠습니까?"
            $0.font = .notoSans(ofSize: 16, weight: .bold)
        }
        trashInfoAddressLabel.font = .notoSans(ofSize: 12, weight: .regular)
        trashInfoDescriptionLabel.do {
            $0.text = "핀을 길게 누르면 위치 수정을 할 수 있습니다."
            $0.font = .notoSans(ofSize: 12, weight: .regular)
        }
        addTrashCanConfirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .roboto(ofSize: 18, weight: .bold)
            $0.backgroundColor = .buttonEnabled
            $0.layer.cornerRadius = 28
            $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.3, x: 0, y: 2, blur: 10, spread: 0)
            $0.addTarget(self, action: #selector(addTrashCanConfirmButtonTapped), for: .touchUpInside)
        }
        closeCoachmarkButton.do {
            $0.setImage(UIImage(named: "btn_ploggingCoachmarkClose"), for: .normal)
            $0.addTarget(self, action: #selector(closeCoachmarkButtonTapped), for: .touchUpInside)
        }
        coachmarkContainer.do {
            $0.backgroundColor = .black.withAlphaComponent(0.6)
            $0.isHidden = true
        }
        coachmarkDeleteTrashcanLabel.do {
            $0.text = "꾹 눌러서 삭제 할 수 있습니다."
            $0.font = .notoSans(ofSize: 14, weight: .regular)
            $0.textColor = .white
        }
        coachmarkTrashcanIcon.do {
            $0.image = UIImage(named: "ic_pinTrashCan")?.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
        coachmarkSmallHandIcon.do {
            $0.image = UIImage(named: "ic_ploggingCoachmarkHandSmall")?.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
        coachmarkAddTrashcanIcon.do {
            $0.image = UIImage(named: "ic_ploggingAddTrashcan")?.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
        coachmarkAddTrashcanLabel.do {
            $0.text = "쓰레기통을 추가 할 수 있습니다."
            $0.font = .notoSans(ofSize: 14, weight: .regular)
            $0.textColor = .white
        }
        coachmarkStartButton.do {
            $0.setTitle("플로깅 시작하기", for: .normal)
            $0.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
            $0.backgroundColor = .buttonEnabled
            $0.layer.cornerRadius = 28
            $0.layer.applySketchShadow(color: .buttonEnabled, alpha: 0.3, x: 0, y: 2, blur: 10, spread: 0)
        }
        coachmarkBigHandIcon.do {
            $0.image = UIImage(named: "ic_ploggingCoachmarkHandBig")?.withRenderingMode(.alwaysOriginal)
            $0.contentMode = .scaleAspectFit
        }
        coachmarkStartButtonLabel.do {
            $0.text = "버튼을 누르면 플로깅을 시작합니다."
            $0.font = .notoSans(ofSize: 14, weight: .regular)
            $0.textColor = .white
        }
        
        addSubview(mapView)
        addSubview(trashButton)
        addSubview(myLocationButton)
        addSubview(startBottomContainerView)
        addSubview(doingPauseBottomContainerView)
        addSubview(trashInfoContainer)
        startBottomContainerView.addSubview(ploggerImageView)
        startBottomContainerView.addSubview(startButton)
        startBottomContainerView.addSubview(bubbleView)
        bubbleView.addSubview(bubbleLabel)
        
        doingPauseBottomContainerView.addSubview(pauseButton)
        doingPauseBottomContainerView.addSubview(stopButton)
        doingPauseBottomContainerView.addSubview(resumeButton)
        doingPauseBottomContainerView.addSubview(distanceContainer)
        doingPauseBottomContainerView.addSubview(timeContainer)
        
        distanceContainer.addSubview(distanceImageView)
        distanceContainer.addSubview(distanceLabel)
        
        timeContainer.addSubview(timeImageView)
        timeContainer.addSubview(timeLabel)
        
        trashInfoContainer.addSubview(trashInfoTitleLabel)
        trashInfoContainer.addSubview(trashInfoAddressLabel)
        trashInfoContainer.addSubview(trashInfoDescriptionLabel)
        trashInfoContainer.addSubview(addTrashCanConfirmButton)
        
        [distanceImageView, timeImageView].forEach{
            $0.tintColor = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        addSubview(coachmarkContainer)
        coachmarkContainer.addSubview(closeCoachmarkButton)
        coachmarkContainer.addSubview(coachmarkDeleteTrashcanLabel)
        coachmarkContainer.addSubview(coachmarkTrashcanIcon)
        coachmarkContainer.addSubview(coachmarkSmallHandIcon)
        coachmarkContainer.addSubview(coachmarkAddTrashcanIcon)
        coachmarkContainer.addSubview(coachmarkAddTrashcanLabel)
        coachmarkContainer.addSubview(coachmarkStartButton)
        coachmarkContainer.addSubview(coachmarkBigHandIcon)
        coachmarkContainer.addSubview(coachmarkStartButtonLabel)
    }
    func layout() {
        mapView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        myLocationButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
            $0.trailing.equalTo(-17)
            $0.width.height.equalTo(40)
        }
        
        trashButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(startBottomContainerView.snp.top).offset(-16)
            $0.width.height.equalTo(50)
        }
        startBottomContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        startButton.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-19)
        }
        ploggerImageView.snp.makeConstraints {
            $0.leading.equalTo(startButton).offset(36)
            $0.bottom.equalTo(startButton).offset(-25.51)
            $0.top.equalTo(32)
        }
        bubbleView.snp.makeConstraints {
            $0.leading.equalTo(ploggerImageView.snp.trailing).offset(2)
            $0.bottom.equalTo(startButton.snp.top).offset(-17)
        }
        bubbleLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.leading.equalTo(22)
            $0.trailing.equalTo(-15)
            $0.bottom.equalTo(-10)
        }
        doingPauseBottomContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        pauseButton.snp.makeConstraints{
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-19)
        }
        
        stopButton.snp.makeConstraints{
            $0.top.leading.bottom.equalTo(pauseButton)
            $0.width.equalToSuperview().multipliedBy(0.5).offset(-24)
        }
        
        resumeButton.snp.makeConstraints{
            $0.top.trailing.bottom.equalTo(pauseButton)
            $0.width.equalToSuperview().multipliedBy(0.5).offset(-24)
        }
        distanceContainer.snp.makeConstraints{
            $0.top.equalTo(32)
            $0.centerX.equalTo(stopButton)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-95)
            
        }
        timeContainer.snp.makeConstraints{
            $0.top.equalTo(32)
            $0.centerX.equalTo(resumeButton)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-95)
        }
        distanceLabel.snp.makeConstraints{
            $0.centerX.bottom.equalToSuperview()
        }
        distanceImageView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.equalTo(26)
            $0.height.equalTo(25.67)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(distanceLabel.snp.top).offset(-3)
        }
        timeLabel.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
        }
        timeImageView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.width.equalTo(22)
            $0.height.equalTo(25.62)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(timeLabel.snp.top).offset(-3)
        }
        trashInfoContainer.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        trashInfoTitleLabel.snp.makeConstraints{
            $0.top.equalTo(30)
            $0.leading.equalTo(12)
            $0.trailing.equalTo(-12)
        }
        trashInfoAddressLabel.snp.makeConstraints{
            $0.top.equalTo(trashInfoTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(12)
            $0.trailing.equalTo(-12)
        }
        trashInfoDescriptionLabel.snp.makeConstraints{
            $0.top.equalTo(trashInfoAddressLabel.snp.bottom).offset(8)
            $0.leading.equalTo(12)
            $0.trailing.equalTo(-12)
        }
        addTrashCanConfirmButton.snp.makeConstraints{
            $0.top.equalTo(trashInfoDescriptionLabel.snp.bottom).offset(16)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.height.equalTo(56)
            $0.bottom.equalTo(-19)
        }
        
        coachmarkContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeCoachmarkButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(-21)
            $0.width.height.equalTo(30)
        }
        
        coachmarkDeleteTrashcanLabel.snp.makeConstraints {
            $0.top.equalTo(closeCoachmarkButton.snp.bottom).offset(52)
            $0.trailing.equalTo(-24)
        }
        
        coachmarkTrashcanIcon.snp.makeConstraints {
            $0.trailing.equalTo(coachmarkDeleteTrashcanLabel.snp.leading).offset(-10)
            $0.centerY.equalTo(coachmarkDeleteTrashcanLabel)
        }
        
        coachmarkSmallHandIcon.snp.makeConstraints {
            $0.top.equalTo(coachmarkTrashcanIcon.snp.centerY)
            $0.leading.equalTo(coachmarkTrashcanIcon.snp.centerX).offset(-8)
        }
        coachmarkAddTrashcanIcon.snp.makeConstraints {
            $0.edges.equalTo(trashButton)
        }
        coachmarkAddTrashcanLabel.snp.makeConstraints{
            $0.trailing.equalTo(coachmarkAddTrashcanIcon.snp.leading).offset(-12)
            $0.centerY.equalTo(coachmarkAddTrashcanIcon)
        }
        coachmarkStartButton.snp.makeConstraints{
            $0.edges.equalTo(startButton)
        }
        coachmarkBigHandIcon.snp.makeConstraints {
            $0.top.equalTo(coachmarkStartButton.snp.bottom).offset(-16)
            $0.leading.equalTo(coachmarkStartButton.snp.centerX).offset(-16)
        }
        
        coachmarkStartButtonLabel.snp.makeConstraints {
            $0.top.equalTo(coachmarkBigHandIcon.snp.bottom).offset(8)
            $0.centerX.equalTo(coachmarkStartButton)
        }
    }
}

extension PloggingMainView: MKMapViewDelegate {
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
        if newState == .ending, let annotation = view.annotation {
            let latitude = annotation.coordinate.latitude
            let longitude = annotation.coordinate.longitude
            listener?.action(.addTrashCan(latitude: latitude, longitude: longitude))
        }
    }
}
