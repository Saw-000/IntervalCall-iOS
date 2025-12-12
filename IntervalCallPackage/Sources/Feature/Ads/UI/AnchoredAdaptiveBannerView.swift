import SwiftUI
import GoogleMobileAds

/// バナー広告
/// widthが決まれば自動で最適な高さが決まる。
public struct AnchoredAdaptiveBannerView: View {
    private let adUnitID: String
    private let width: CGFloat
    
    public var body: some View {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        AdMobBannerView(adSize: adSize, adUnitID: adUnitID)
            .frame(width: width, height: adSize.size.height)
            .frame(alignment: .center)
    }
    
    public init(adUnitID: String, width: CGFloat) {
        self.adUnitID = adUnitID
        self.width = width
    }
}
