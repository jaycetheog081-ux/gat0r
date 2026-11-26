import Foundation

enum KernelProfileStatus: String {
    case referenceOnly = "REFERENCE_ONLY"
    case verified = "VERIFIED"
    case unsupported = "UNSUPPORTED"
    case unknown = "UNKNOWN"
}

struct KernelProfile {
    let identifier: String
    let deviceFamily: String
    let status: KernelProfileStatus
    let source: String
    let notes: String
}

struct KernelProfileRegistry {

    static let profiles: [KernelProfile] = [

        KernelProfile(
            identifier: "Darwin Kernel Version 18.2.0, xnu-4903.232.2~1, RELEASE_ARM64_S8000",
            deviceFamily: "Apple A9 family",
            status: .referenceOnly,
            source: "PsychoTea/machswap2",
            notes: "Upstream reference entry. Not independently validated by gat0r."
        ),

        KernelProfile(
            identifier: "Darwin Kernel Version 18.2.0, xnu-4903.232.2~1, RELEASE_ARM64_T8010",
            deviceFamily: "Apple A11 family",
            status: .referenceOnly,
            source: "PsychoTea/machswap2",
            notes: "Upstream reference entry. Not independently validated by gat0r."
        ),

        KernelProfile(
            identifier: "Darwin Kernel Version 17.7.0, xnu-4570.70.24~3, RELEASE_ARM64_S5L8960X",
            deviceFamily: "Apple A7 family",
            status: .referenceOnly,
            source: "PsychoTea/machswap2",
            notes: "Upstream reference entry. Not independently validated by gat0r."
        ),

        KernelProfile(
            identifier: "Darwin Kernel Version 16.7.0, xnu-3789.70.16~4, RELEASE_ARM64_S5L8960X",
            deviceFamily: "Apple A7 family",
            status: .referenceOnly,
            source: "PsychoTea/machswap2",
            notes: "Upstream reference entry. Not independently validated by gat0r."
        )
    ]

    static func lookup(kernelVersion: String) -> KernelProfile? {
        return profiles.first {
            kernelVersion.contains($0.identifier)
        }
    }

    static func status(for kernelVersion: String) -> KernelProfileStatus {
        guard let profile = lookup(kernelVersion: kernelVersion) else {
            return .unknown
        }

        return profile.status
    }

    static func report(for kernelVersion: String) -> String {
        guard let profile = lookup(kernelVersion: kernelVersion) else {
            return [
                "KERNEL PROFILE",
                "--------------",
                "Status: UNKNOWN",
                "No matching reference profile was found.",
                "Exploit compatibility has not been established."
            ].joined(separator: "\n")
        }

        return [
            "KERNEL PROFILE",
            "--------------",
            "Identifier: \(profile.identifier)",
            "Device family: \(profile.deviceFamily)",
            "Status: \(profile.status.rawValue)",
            "Source: \(profile.source)",
            "Notes: \(profile.notes)"
        ].joined(separator: "\n")
    }
}
