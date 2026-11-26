import Foundation
import UIKit

enum FirmwareProfileStatus: String {
    case candidate = "TARGET_CANDIDATE"
    case outsideTarget = "OUTSIDE_TARGET"
}

struct FirmwareAudit {
    let productType: String
    let iosVersion: String
    let osBuild: String
    let kernelVersion: String
    let architecture: String
    let status: FirmwareProfileStatus
    let notes: [String]

    static var current: FirmwareAudit {
        var system = utsname()
        uname(&system)

        let productType = withUnsafePointer(to: &system.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }

        let kernelVersion = withUnsafePointer(to: &system.version) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }

        let iosVersion = UIDevice.current.systemVersion

        let systemPlist = NSDictionary(
            contentsOfFile: "/System/Library/CoreServices/SystemVersion.plist"
        )

        let build = systemPlist?["ProductBuildVersion"] as? String
            ?? "Unavailable"

        #if arch(arm64)
        let architecture = "ARM64"
        #else
        let architecture = "Unsupported"
        #endif

        let components = iosVersion
            .split(separator: ".")
            .compactMap { Int($0) }

        let major = components.first ?? 0
        let minor = components.count > 1 ? components[1] : 0
        let patch = components.count > 2 ? components[2] : 0

        let inTargetRange = major == 11 &&
            (minor < 4 || (minor == 4 && patch <= 1))

        let status: FirmwareProfileStatus

        if architecture != "ARM64" || !inTargetRange {
            status = .outsideTarget
        } else {
            status = .candidate
        }

        return FirmwareAudit(
            productType: productType,
            iosVersion: iosVersion,
            osBuild: build,
            kernelVersion: kernelVersion,
            architecture: architecture,
            status: status,
            notes: [
                "Read-only firmware fingerprint.",
                "Target-range match does not prove exploit compatibility.",
                "No kernel offsets or exploit operations are performed.",
                "Exact device/build support remains unverified."
            ]
        )
    }

    var formattedReport: String {
        return [
            "GAT0R FIRMWARE AUDIT",
            "-------------------",
            "Product: \(productType)",
            "iOS: \(iosVersion)",
            "Build: \(osBuild)",
            "Kernel: \(kernelVersion)",
            "Architecture: \(architecture)",
            "Status: \(status.rawValue)",
            "",
            notes.map { "• \($0)" }.joined(separator: "\n")
        ].joined(separator: "\n")
    }
}
