//
//  Interestitials.swift
//  quran
//
//  Created by developer on 5/17/22.
//

//import GoogleMobileAds
//import SwiftUI
//import UIKit
//
//
//enum adUnitIDs: String {
//    case interestitials = "ca-app-pub-8689408596321744/7661458826"
//}
//
//
//final class Interestitials: NSObject, GADFullScreenContentDelegate {
//
//    var adUnitID: adUnitIDs
//    var willDismiss: ()->Void
//
//    private var interestitials: GADInterstitialAd?
//
//    init(adUnitID: adUnitIDs, willDismiss: @escaping( ()->Void )) {
//        self.willDismiss = willDismiss
//        self.adUnitID = adUnitID
//        super.init()
//        self.loadInterestitials()
//    }
//
//    deinit {
//        print("interestitials deinited!")
//    }
//
//    func loadInterestitials() {
//        let request = GADRequest()
//
//        GADInterstitialAd.load(withAdUnitID: adUnitID.rawValue, request: request){ [weak self] ad, error in
//
//            if let error = error {
//                print(error)
//                return
//            }
//
//            guard let ad = ad else { return }
//
//            self?.interestitials = ad
//            self?.interestitials?.fullScreenContentDelegate = self
//            self?.showAd()
//        }
//    }
//
//    private func showAd() {
//        guard self.interestitials != nil else { return }
//
//        let scenes = UIApplication.shared.connectedScenes
//        let windowScene = scenes.first as? UIWindowScene
//        if let rootVC = windowScene?.windows.first?.rootViewController {
//
//            self.interestitials?.present(fromRootViewController: rootVC)
//        }
//    }
//
//    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//
//        print(error)
//    }
//
//    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        willDismiss()
//        interestitials = nil
//    }
//
//}
