import Foundation

struct JailbreakCoordinator {

    static let shared = JailbreakCoordinator()

    private init() {}

    func start(completion: @escaping (Bool, String) -> Void) {
        GTRLogger.shared.log("Jailbreak request received.")

        let device = DeviceInfo.current

        guard device.isCompatible else {
            let message = "This device does not match gat0r's iOS 11.0–11.4.1 ARM64 target."
            GTRLogger.shared.log("Rejected: \(message)")

            DispatchQueue.main.async {
                completion(false, message)
            }
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            GTRLogger.shared.log("Checking exploit backend availability.")

            let result = machswap2_run()
            let message: String

            if result.success {
                message = "The exploit bridge returned success, but the post-exploit and bootstrap chain is not implemented. No jailbreak is being reported."
                GTRLogger.shared.log("Backend returned success; post-exploit chain unavailable.")
            } else {
                message = String(cString: result.error_msg)
                GTRLogger.shared.log("Backend unavailable: \(message)")
            }

            DispatchQueue.main.async {
                completion(false, message)
            }
        }
    }
}
