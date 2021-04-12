import UIKit
import LocalAuthentication
import Slab
import AudioToolbox

extension UIDevice {
    public enum BiometryType: CustomStringConvertible {
        case touchID
        case faceID
        
        public var description: String {
            switch self {
                case .touchID: return "Touch ID"
                case .faceID: return "Face ID"
            }
        }
    }
    
    public var biometryType: BiometryType? {
        let ctx = LAContext()
        let _ = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch ctx.biometryType {
            case .touchID: return .touchID
            case .faceID: return .faceID
            default: return nil
        }
    }
    
    public func authenticate(reason: String, then: @escaping (Bool, Error?) -> Void) {
        guard biometryType != nil else { then(false, nil); return }
        
        let ctx = LAContext()
        ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (ret, err) in
            DispatchQueue.main.async {
                then(ret, err)
            }
        }
    }
    
    public static func feedbackError() {
        switch UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int ?? 0 {
            case 1:
                AudioServicesPlaySystemSound(1521)
                
            case 2:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
                
            default:
                return
        }
    }
}
