import UIKit
import LocalAuthentication
import Slab

public extension UIDevice {
    enum BiometryType: CustomStringConvertible {
        case touchID
        case faceID
        
        public var description: String {
            switch self {
                case .touchID: return "Touch ID"
                case .faceID: return "Face ID"
            }
        }
    }
    
    var biometryType: BiometryType? {
        let ctx = LAContext()
        let _ = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch ctx.biometryType {
            case .touchID: return .touchID
            case .faceID: return .faceID
            default: return nil
        }
    }
    
    func authenticate(reason: String, then: @escaping (Bool, Error?) -> Void) {
        guard biometryType != nil else { then(false, nil); return }
        
        let ctx = LAContext()
        ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (ret, err) in
            DispatchQueue.main.async {
                then(ret, err)
            }
        }
        
    }
}
