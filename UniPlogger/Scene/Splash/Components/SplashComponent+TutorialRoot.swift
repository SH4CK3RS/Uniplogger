//
//  SplashComponent+TutorialRoot.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation

extension SplashComponent: TutorialRootDependency {
    var tutorialRootViewController: TutorialRootViewControllable {
        splashViewController
    }
}
