import Foundation

final class GTRLogger {

    static let shared = GTRLogger()

    private let queue = DispatchQueue(
        label: "com.gat0r.logger"
    )

    private var storage: [String] = []

    private let key = "GTRLogs"

    private init() {
        storage = UserDefaults.standard.stringArray(
            forKey: key
        ) ?? []
    }

    func log(_ message: String) {

        queue.async {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"

            let timestamp = formatter.string(
                from: Date()
            )

            let entry = "[\(timestamp)] \(message)"

            self.storage.append(entry)

            if self.storage.count > 500 {
                self.storage.removeFirst()
            }

            UserDefaults.standard.set(
                self.storage,
                forKey: self.key
            )
        }
    }

    func entries() -> [String] {

        return queue.sync {
            storage
        }
    }

    func clear() {

        queue.async {
            self.storage.removeAll()

            UserDefaults.standard.removeObject(
                forKey: self.key
            )
        }
    }
}
