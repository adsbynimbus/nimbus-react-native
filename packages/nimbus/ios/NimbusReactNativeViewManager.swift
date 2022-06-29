import NimbusKit
import NimbusRenderStaticKit
import NimbusRenderVideoKit

@objc(NimbusReactNativeViewManager)
class NimbusReactNativeViewManager: RCTViewManager {

  override func view() -> (NimbusReactNativeView) {
    return NimbusReactNativeView()
  }
}

class NimbusReactNativeView : UIView {

  @objc var color: String = "" {
    didSet {
      self.backgroundColor = hexStringToUIColor(hexColor: color)
    }
  }

  let adManager = NimbusAdManager()

    override init(frame: CGRect) {
        super.init(frame: frame)

        if let vc = RCTPresentedViewController() {
            Nimbus.shared.initialize(
                 publisher: "dev-sdk",
                 apiKey: "DEV-cae2-4774-97ba-4e15c6276be0"
             )
            Nimbus.shared.testMode = true

             Nimbus.shared.renderers = [
                 .forAuctionType(.static): NimbusStaticAdRenderer(),
                 .forAuctionType(.video): NimbusVideoAdRenderer()
             ]

           adManager.showBlockingAd(request: NimbusRequest.forInterstitialAd(position: "React Native Sample"), adPresentingViewController: vc)
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

  func hexStringToUIColor(hexColor: String) -> UIColor {
    let stringScanner = Scanner(string: hexColor)

    if(hexColor.hasPrefix("#")) {
      stringScanner.scanLocation = 1
    }
    var color: UInt32 = 0
    stringScanner.scanHexInt32(&color)

    let r = CGFloat(Int(color >> 16) & 0x000000FF)
    let g = CGFloat(Int(color >> 8) & 0x000000FF)
    let b = CGFloat(Int(color) & 0x000000FF)

    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
  }
}

extension UIView {
  var parentViewController: UIViewController? {
      var parentResponder: UIResponder? = self
      while parentResponder != nil {
          parentResponder = parentResponder!.next
          if let viewController = parentResponder as? UIViewController {
              return viewController
          }
      }
      return nil
    }
}

public extension UIWindow {
    static var key: UIWindow? { UIApplication.shared.windows.first { $0.isKeyWindow } }
}
