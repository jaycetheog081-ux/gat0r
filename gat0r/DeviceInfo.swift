import Foundation
import UIKit

struct DeviceInfo {

    let model: String
    let version: String
    let architecture: String
    let isArm64: Bool
    let isCompatible: Bool
    let compatibilityReason: String

    static var current: DeviceInfo {

        var systemInfo = utsname()
        uname(&systemInfo)

        let model = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(
                to: CChar.self,
                capacity: 1
            ) {
                String(cString: $0)
            }
        }

        let version = UIDevice.current.systemVersion

        #if arch(arm64)
        let arm64 = true
        let architecture = "ARM64"
        #else
        let arm64 = false
        let architecture = "Unsupported"
        #endif

        let components = version
            .split(separator: ".")
            .compactMap { Int($0) }

        let major = components.first ?? 0
        let minor = components.count > 1 ? components[1] : 0
        let patch = components.count > 2 ? components[2] : 0

        let compatibleVersion =
            major == 11 &&
            (
                minor < 4 ||
                (minor == 4 && patch <= 1)
            )

        let compatible = arm64 && compatibleVersion

        let reason: String

        if !arm64 {
            reason = "ARM64 architecture required."
        } else if !compatibleVersion {
            reason = "Supported versions: iOS 11.0–11.4.1."
        } else {
            reason = "Device matches target architecture and version."
        }

        return DeviceInfo(
            model: model,
            version: version,
            architecture: architecture,
            isArm64: arm64,
            isCompatible: compatible,
            compatibilityReason: reason
        )
    }
}
