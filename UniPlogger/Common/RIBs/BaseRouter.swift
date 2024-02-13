//
//  BaseRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import RIBs
import UIKit

class BaseRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>,
                                                      ErrorShowableRouting where InteractorType: Interactable, ViewControllerType: ViewControllable {
     private let errorAlertBuilder: ErrorAlertBuildable
     
     init(interactor: InteractorType, viewController: ViewControllerType, errorAlertBuilder: ErrorAlertBuildable) {
         self.errorAlertBuilder = errorAlertBuilder
         super.init(interactor: interactor, viewController: viewController)
     }
     
     func showErrorAlert(withMessage message: String) {
         // 에러 알림 RIB을 구성하고 표시하는 로직
         // 예제 코드에서는 단순화를 위해 UIViewController를 직접 사용합니다.
         let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.viewController.uiviewController.present(alertController, animated: true, completion: nil)
     }
}
