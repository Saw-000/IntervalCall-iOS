import SwiftUI
import GoogleMobileAds

/// バナー広告
/// widthが決まれば自動で最適な高さが決まる。
public struct AnchoredAdaptiveBannerView: View {
    private let width: CGFloat
    
    public var body: some View {
        let adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        AdMobBannerView(adSize: adSize)
            .frame(width: width, height: adSize.size.height)
            .frame(alignment: .center)
    }
    
    public init(width: CGFloat) {
        self.width = width
    }
}
