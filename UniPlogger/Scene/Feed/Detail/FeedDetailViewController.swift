//
//  FeedDetailViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol FeedDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class FeedDetailViewController: UIViewController, FeedDetailPresentable, FeedDetailViewControllable {

    weak var listener: FeedDetailPresentableListener?
}
