//
//  SplashViewController.swift
//  YRStor
//
//  Created by Aya Mohamed Ahmed on 01/06/2023.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    var animation:LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LottieAnimation()
        print("splash view controller")
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now()+3) {
            let onboarding = self.storyboard?.instantiateViewController(withIdentifier: "onboardingViewController") as! onboardingViewController
            onboarding.modalPresentationStyle = .fullScreen
            onboarding.modalTransitionStyle = .flipHorizontal
            self.present(onboarding, animated: true)
        }
    }
    func LottieAnimation(){
        animation = .init(name:"SplashLottie")
        animation.frame = view.bounds
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        view.addSubview(animation)
        animation.play()
    }
    
}
