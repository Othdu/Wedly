import Foundation
import GoogleMobileAds
import UIKit

// Simple Native Ad Factory rendering a title and call-to-action button
class ListTileNativeAdFactory: NSObject, FLTNativeAdFactory {
  func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
    let adView = GADNativeAdView(frame: .zero)
    adView.translatesAutoresizingMaskIntoConstraints = false

    // Media view for main image/video
    let mediaView = GADMediaView()
    mediaView.translatesAutoresizingMaskIntoConstraints = false
    mediaView.contentMode = .scaleAspectFill
    mediaView.clipsToBounds = true

    let headlineView = UILabel()
    headlineView.numberOfLines = 2
    headlineView.font = UIFont.preferredFont(forTextStyle: .headline)
    headlineView.translatesAutoresizingMaskIntoConstraints = false

    let callToActionButton = UIButton(type: .system)
    callToActionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
    callToActionButton.translatesAutoresizingMaskIntoConstraints = false
    callToActionButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
    callToActionButton.layer.cornerRadius = 8
    callToActionButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

    let stack = UIStackView(arrangedSubviews: [mediaView, headlineView, callToActionButton])
    stack.axis = .vertical
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false

    adView.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: adView.topAnchor, constant: 12),
      stack.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 12),
      stack.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -12),
      stack.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -12),
      mediaView.heightAnchor.constraint(equalToConstant: 140)
    ])

    // Wire views
    adView.mediaView = mediaView
    adView.headlineView = headlineView
    adView.callToActionView = callToActionButton

    // Populate
    (adView.headlineView as? UILabel)?.text = nativeAd.headline
    (adView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
    adView.mediaView?.mediaContent = nativeAd.mediaContent

    adView.nativeAd = nativeAd
    // Disable user interaction on CTA to let the SDK handle clicks
    adView.callToActionView?.isUserInteractionEnabled = false

    return adView
  }
}


