import GoogleMobileAds
import SwiftUI
import UIKit

/// AdMobバナー広告の共通ラッパー
struct AdMobBannerView: UIViewRepresentable {
    typealias UIViewType = BannerView

    private let adSize: AdSize
    private let adUnitID: String

    init(adSize: AdSize, adUnitID: String) {
        self.adSize = adSize
        self.adUnitID = adUnitID
    }

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        // load_ad
        banner.adUnitID = adUnitID
        banner.load(Request())

        // set delegate
        banner.delegate = context.coordinator

        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, BannerViewDelegate {

        // MARK: - GADBannerViewDelegate methods

        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
          print("DID RECEIVE AD.")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
          print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
        }
    }
}
