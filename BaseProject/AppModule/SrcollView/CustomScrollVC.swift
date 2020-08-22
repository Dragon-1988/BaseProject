//
//  CustomScrollVC.swift
//  BaseProject
//
//  Created by Michael Seven on 4/23/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import UIKit
import RxSwift

class CustomScrollVC: UIViewController {
    
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    let shorcutView = UIView()
    var subView = UIView()
    let animateBtn = UIButton()
    var isShowView = false
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        subscribeEvents()
    }

    private func setupViews() {
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.backgroundColor = .blue
//        self.view.addSubview(animateBtn)
//        animateBtn.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.height.width.equalTo(50)
//        }
//        animateBtn.backgroundColor = .red
        
        self.view.addSubview(shorcutView)
        shorcutView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(100)
            $0.height.equalTo(100)
        }
        shorcutView.backgroundColor = .brown
        
    }
    private func subscribeEvents() {
        animateBtn.rx.tap.asDriver()
            .drive(onNext: { _ in
                self.animateView()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Scroll Delegate
extension CustomScrollVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if actualPosition.y > 0 {
            print("7_ scroll down")
            if !isShowView {
                self.shorcutView.animShow()
                isShowView = !isShowView
            }
        } else {
            print("7_ scroll up")
            if isShowView {
                self.shorcutView.animHide()
                isShowView = !isShowView
            }
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("7_ scrollViewWillBeginDragging")
//        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        if actualPosition.y > 0 {
//            print("7_ scroll down")
//            if !isShowView {
//                self.shorcutView.animShow()
//                isShowView = !isShowView
//            }
//        } else {
//            print("7_ scroll up")
//            if isShowView {
//                self.shorcutView.animHide()
//                isShowView = !isShowView
//            }
//        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("7_ scrollViewDidEndDecelerating")
//        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        if actualPosition.y > 0 {
//            print("7_ scroll down")
//            if !isShowView {
//                self.shorcutView.animShow()
//                isShowView = !isShowView
//            }
//        } else {
//            print("7_ scroll up")
//            if isShowView {
//                self.shorcutView.animHide()
//                isShowView = !isShowView
//            }
//        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("7_ scrollViewWillEndDragging")
    }
}

extension CustomScrollVC {
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: 500, height: 5000)

        scrollView.addSubview(subView)
        subView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        subView.backgroundColor = .white
        let label = UILabel()
        label.text = "abc"
        scrollView.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
//        subView.bringSubviewToFront(scrollView)
    }
    
    private func animateView() {
        if isShowView {
            shorcutView.animHide()
        } else {
            shorcutView.animShow()
        }
        isShowView = !isShowView
    }
}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y -= 100
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += 100
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}
