//
//  SocialVM.swift
//  BaseProject
//
//  Created by Michael Seven on 2/16/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import Foundation
import RxSwift

class SocialVM {
    
    let disposeBag = DisposeBag()
    let doLoginEvent = PublishSubject<Void>()
    let socialManager = SocialManager()
    let socialResult = Variable<SocialLoginResult?>(nil)
    
    init() {
        //subscribe events
        doLoginEvent.asObserver()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let type = SocialType.google
                //do login
                self.socialManager.login(socialType: type, viewController: nil, result: {
                    result in
                    print("login google: result = \(result)")
                    self.socialResult.value = result
                })
            })
            .disposed(by: disposeBag)
    }
}
