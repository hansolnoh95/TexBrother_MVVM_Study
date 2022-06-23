//
//  RiveViewController.swift
//  TexBrother_MVVM_Study
//
//  Created by hansol on 2022/06/23.
//

import UIKit

import RiveRuntime
import RxSwift
import SnapKit
import Then

// MARK: - RIveViewController

final class RiveViewController: UIViewController {

    // MARK: - Lazy Components
    
    private lazy var riveViewModel: RiveViewModel = {
        let viewModel = RiveViewModel(fileName: "switch", fit: .fitContain, alignment: .alignmentCenter, autoPlay: true)
        return viewModel
    }()
    
    // MARK: - Components
    
    private let riveView = RiveView()
    
    // MARK: - Variables
    
    var isRiveOn: Bool = false
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layout()
    }
}

// MARK: - Extensions

extension RiveViewController {
    
    // MARK: - Layout Helpers
    
    private func layout() {
        view.backgroundColor = .white
        view.add(riveView)
        riveViewModel.setView(riveView)
        
        riveView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - General Helpers
    
    private func config() {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(onTappedRiveView))
        riveView.addGestureRecognizer(gesture)
    }
    
    // MARK: - Action Helpers
    
    @objc
    private func onTappedRiveView() {
        if isRiveOn {
            isRiveOn = false
            riveViewModel.play(animationName: "Off", loop: .loopOneShot, direction: .directionAuto)
        }
        else {
            isRiveOn = true
            riveViewModel.play(animationName: "On", loop: .loopOneShot, direction: .directionAuto)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: {
                self.riveViewModel.play(animationName: "IdleOn", loop: .loopLoop, direction: .directionAuto)
            })
        }
    }
}
