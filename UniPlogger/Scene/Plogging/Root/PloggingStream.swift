//
//  PloggingStream.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import Foundation
import RxSwift

protocol PloggingStream: AnyObject {
    var countingFinishedObservable: Observable<Void> { get }
}

protocol PloggingMutableStream: PloggingStream {
    func updateCountingFinished()
}

final class PloggingStreamImpl: PloggingMutableStream {
    private let countingFinishedSubject = PublishSubject<Void>()
    var countingFinishedObservable: Observable<Void> {
        countingFinishedSubject.asObservable()
    }
    func updateCountingFinished() {
        countingFinishedSubject.onNext(())
    }
}
