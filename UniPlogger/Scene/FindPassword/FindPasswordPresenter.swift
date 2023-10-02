//
//  FindPasswordPresenter.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/11.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FindPasswordPresentationLogic {
    func presentValidateAccount(response: FindPassword.ValidateAccount.Response)
    func presentFindPassword(response: FindPassword.FindPassword.Response)
}

class FindPasswordPresenter: FindPasswordPresentationLogic {
    weak var viewController: FindPasswordDisplayLogic?
    var isValidAccount: Bool = false
    
    func presentValidateAccount(response: FindPassword.ValidateAccount.Response) {
        self.isValidAccount = response.isValid
        let viewModel = FindPassword.ValidationViewModel(isValid: isValidAccount)
        viewController?.displayValidation(viewModel: viewModel)
    }
    
    func presentFindPassword(response: FindPassword.FindPassword.Response) {
        guard let data = response.data?.detail, response.error == nil else {
            self.viewController?.displayError(error: response.error!, useCase: .FindPassword(response.request))
            return
        }
        
        let viewModel = FindPassword.FindPassword.ViewModel(data: data)
        self.viewController?.displayFindPassword(viewModel: viewModel)
    }
}
