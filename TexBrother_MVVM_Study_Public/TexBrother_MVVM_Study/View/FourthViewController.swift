//
//  FourthViewController.swift
//  TexBrother_MVVM_Study
//
//  Created by hansol on 2022/03/13.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then
import MapKit

// MARK: - FourthViewController

final class FourthViewController: BaseViewController {
    
    // MARK: - Components
    
    private let randomImageView = UIImageView()
    
    // MARK: - Variables
    
    var timeTrigger: Bool = true
    var realTime = Timer()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAction()
    }
}

// MARK: - Extensions

extension FourthViewController {
    
    // MARK: - Layout Helpers
    
    private func layout() {
        view.add(randomImageView) {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(400.adjusted)
                $0.height.equalTo(300.adjusted )
            }
        }
    }
    
    // MARK: - General Helpers
    
    private func startAction() {
        if timeTrigger {
            checkTimeTrigger()
        }
    }
    
    private func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                selector: #selector(bind), userInfo: nil, repeats: true)
            timeTrigger = false
    }
    
    // MARK: - Action Helpers
    
    @objc private func bind() {
        Observable.just("3840x2160")
//            .observe(on: MainScheduler.instance)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { image in
                self.randomImageView.image = image
                print(NSDate.now)
            }, onCompleted: {})
            .disposed(by: disposeBag)
    }
}

