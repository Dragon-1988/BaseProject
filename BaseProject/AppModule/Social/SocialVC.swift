//
//  SocialVC.swift
//  BaseProject
//
//  Created by Michael Seven on 2/16/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import MessageUI

class SocialVC: UIViewController {
    
    let viewModel = SocialVM()
    let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initComponents()
    }
}

// MARK: - Init components
extension SocialVC {
    func initComponents() {
        self.view.backgroundColor = .white
        let stackView = UIStackView()
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints( {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        } )
        
        // create SNS button
        let googleBtn = UIButton()
        googleBtn.setTitle("Sign in with Google", for: .normal)
        googleBtn.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        googleBtn.layer.cornerRadius = 8
        googleBtn.backgroundColor = .blue
        googleBtn.setTitleColor(.white, for: .normal)
        stackView.addArrangedSubview(googleBtn)
        
        /**
         Sign in with Google account
        **/
        googleBtn.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.doLoginEvent.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
}
