import Foundation

enum JailbreakState {
    case idle
    case preparing
    case exploiting
    case bootstrapping
    case jailbroken
    case failed
}

enum ExploitResult {
    case success
    case unsupported
    case failed
    case cancelled
}

protocol ExploitBackend: AnyObject {

    var name: String { get }

    func prepare(
        completion: @escaping (ExploitResult, String) -> Void
    )

    func cancel()
}

final class JailbreakCoordinator {

    static let shared = JailbreakCoordinator()

    private let queue = DispatchQueue(
        label: "com.gat0r.jailbreak"
    )

    private(set) var state: JailbreakState = .idle

    private var operationActive = false

    // No executable exploit backend is connected yet.
    private var backend: ExploitBackend?

    private init() {}

    func start(
        completion: @escaping (Bool, String) -> Void
    ) {

        queue.async {

            guard !self.operationActive else {
                DispatchQueue.main.async {
                    completion(false, "An operation is already running.")
                }
                return
            }

            self.operationActive = true
            self.state = .preparing

            GTRLogger.shared.log(
                "Starting gat0r compatibility checks."
            )

            let device = DeviceInfo.current

            guard device.isCompatible else {

                self.state = .failed
                self.operationActive = false

                GTRLogger.shared.log(
                    device.compatibilityReason
                )

                DispatchQueue.main.async {
                    completion(false, device.compatibilityReason)
                }

                return
            }

            GTRLogger.shared.log(
                "Device compatibility confirmed."
            )

            guard let backend = self.backend else {

                self.state = .failed
                self.operationActive = false

                let message =
                    "No executable exploit backend is connected."

                GTRLogger.shared.log(message)

                DispatchQueue.main.async {
                    completion(false, message)
                }

                return
            }

            self.state = .exploiting

            backend.prepare { result, message in

                self.queue.async {

                    let success: Bool

                    switch result {
                    case .success:
                        self.state = .exploiting
                        success = true

                    case .unsupported, .failed, .cancelled:
                        self.state = .failed
                        success = false
                    }

                    GTRLogger.shared.log(message)

                    self.operationActive = false

                    DispatchQueue.main.async {
                        completion(success, message)
                    }
                }
            }
        }
    }

    func reset() {

        queue.async {

            guard !self.operationActive else {
                return
            }

            self.state = .idle

            GTRLogger.shared.log(
                "Coordinator reset."
            )
        }
    }
}
