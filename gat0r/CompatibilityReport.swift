import Foundation

enum CompatibilityLevel: String {
    case referenceMatch = "REFERENCE_MATCH"
    case firmwareCandidate = "FIRMWARE_CANDIDATE"
    case unsupported = "UNSUPPORTED"
    case unknown = "UNKNOWN"
}

struct CompatibilityReport {

    let level: CompatibilityLevel
    let firmware: FirmwareAudit
    let kernelProfile: KernelProfile?
    let findings: [String]

    static func evaluate(
        firmware: FirmwareAudit = FirmwareAudit.current
    ) -> CompatibilityReport {

        let profile = KernelProfileRegistry.lookup(
            kernelVersion: firmware.kernelVersion
        )

        var findings: [String] = []

        guard firmware.status == .candidate else {
            findings.append("Firmware is outside gat0r's declared target range.")

            return CompatibilityReport(
                level: .unsupported,
                firmware: firmware,
                kernelProfile: profile,
                findings: findings
            )
        }

        findings.append("Firmware matches the declared iOS 11 target range.")

        guard let matchedProfile = profile else {
            findings.append("No matching kernel reference was found.")
            findings.append("Device and exploit compatibility remain unknown.")

            return CompatibilityReport(
                level: .firmwareCandidate,
                firmware: firmware,
                kernelProfile: nil,
                findings: findings
            )
        }

        findings.append(
            "Matched upstream reference: \(matchedProfile.source)."
        )

        findings.append(
            "Reference status: \(matchedProfile.status.rawValue)."
        )

        findings.append(
            "This match does not establish that gat0r supports this device."
        )

        let level: CompatibilityLevel =
            matchedProfile.status == .verified
            ? .referenceMatch
            : .firmwareCandidate

        return CompatibilityReport(
            level: level,
            firmware: firmware,
            kernelProfile: matchedProfile,
            findings: findings
        )
    }

    var formattedReport: String {
        let profileName = kernelProfile?.deviceFamily ?? "Unknown"

        return [
            "GAT0R COMPATIBILITY REPORT",
            "==========================",
            "Device: \(firmware.productType)",
            "iOS: \(firmware.iosVersion)",
            "Build: \(firmware.osBuild)",
            "Architecture: \(firmware.architecture)",
            "Kernel family: \(profileName)",
            "Result: \(level.rawValue)",
            "",
            "FINDINGS",
            "--------",
            findings.map { "• \($0)" }.joined(separator: "\n"),
            "",
            "No exploit was executed.",
            "No kernel memory was modified."
        ].joined(separator: "\n")
    }
}
