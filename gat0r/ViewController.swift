import UIKit

final class ViewController: UIViewController {

    private let background = UIColor(
        red: 0.035,
        green: 0.055,
        blue: 0.075,
        alpha: 1
    )

    private let accent = UIColor(
        red: 0.35,
        green: 0.95,
        blue: 0.58,
        alpha: 1
    )

    private let scrollView = UIScrollView()

    private let versionLabel = UILabel()
    private let deviceLabel = UILabel()
    private let statusLabel = UILabel()
    private let logsLabel = UILabel()

    private let jailbreakButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = background

        buildInterface()
        refreshDevice()
        refreshLogs()

        GTRLogger.shared.log("gat0r initialized.")
        refreshLogs()
    }

    private func makeLabel(
        _ text: String,
        size: CGFloat,
        color: UIColor
    ) -> UILabel {

        let label = UILabel()

        label.text = text
        label.font = .systemFont(
            ofSize: size,
            weight: .medium
        )
        label.textColor = color
        label.numberOfLines = 0

        return label
    }

    private func makePanel() -> UIView {

        let panel = UIView()

        panel.backgroundColor = UIColor(
            red: 0.075,
            green: 0.105,
            blue: 0.135,
            alpha: 1
        )

        panel.layer.cornerRadius = 14

        return panel
    }

    private func buildInterface() {

        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]

        view.addSubview(scrollView)

        let content = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.bounds.width,
                height: 750
            )
        )

        scrollView.addSubview(content)

        let width = view.bounds.width

        let logo = makeLabel(
            "gat0r",
            size: 40,
            color: accent
        )

        logo.font = .systemFont(
            ofSize: 40,
            weight: .black
        )

        logo.frame = CGRect(
            x: 24,
            y: 45,
            width: width - 48,
            height: 48
        )

        content.addSubview(logo)

        let subtitle = makeLabel(
            "iOS 11 JAILBREAK PROJECT",
            size: 11,
            color: .lightGray
        )

        subtitle.frame = CGRect(
            x: 26,
            y: 94,
            width: width - 52,
            height: 20
        )

        content.addSubview(subtitle)

        let devicePanel = makePanel()

        devicePanel.frame = CGRect(
            x: 20,
            y: 140,
            width: width - 40,
            height: 130
        )

        content.addSubview(devicePanel)

        versionLabel.frame = CGRect(
            x: 16,
            y: 18,
            width: width - 72,
            height: 24
        )

        versionLabel.textColor = .white
        versionLabel.font = .systemFont(ofSize: 15)

        devicePanel.addSubview(versionLabel)

        deviceLabel.frame = CGRect(
            x: 16,
            y: 49,
            width: width - 72,
            height: 24
        )

        deviceLabel.textColor = .lightGray
        deviceLabel.font = .systemFont(ofSize: 13)

        devicePanel.addSubview(deviceLabel)

        let target = makeLabel(
            "TARGET  ·  iOS 11.0 – 11.4.1",
            size: 11,
            color: accent
        )

        target.frame = CGRect(
            x: 16,
            y: 85,
            width: width - 72,
            height: 20
        )

        devicePanel.addSubview(target)

        statusLabel.frame = CGRect(
            x: 24,
            y: 292,
            width: width - 48,
            height: 28
        )

        statusLabel.font = .systemFont(
            ofSize: 12,
            weight: .bold
        )

        statusLabel.textColor = .orange

        content.addSubview(statusLabel)

        jailbreakButton.frame = CGRect(
            x: 20,
            y: 340,
            width: width - 40,
            height: 58
        )

        jailbreakButton.backgroundColor = UIColor(
            red: 0.18,
            green: 0.70,
            blue: 0.40,
            alpha: 1
        )

        jailbreakButton.setTitle(
            "START JAILBREAK",
            for: .normal
        )

        jailbreakButton.setTitleColor(
            .white,
            for: .normal
        )

        jailbreakButton.titleLabel?.font =
            .systemFont(ofSize: 15, weight: .bold)

        jailbreakButton.layer.cornerRadius = 12

        jailbreakButton.addTarget(
            self,
            action: #selector(startJailbreak),
            for: .touchUpInside
        )

        content.addSubview(jailbreakButton)

        let bootstrapButton = UIButton(type: .system)

        bootstrapButton.frame = CGRect(
            x: 20,
            y: 414,
            width: width - 40,
            height: 48
        )

        bootstrapButton.setTitle(
            "CHECK BOOTSTRAP",
            for: .normal
        )

        bootstrapButton.setTitleColor(
            .white,
            for: .normal
        )

        bootstrapButton.layer.cornerRadius = 10
        bootstrapButton.layer.borderWidth = 1
        bootstrapButton.layer.borderColor =
            UIColor.white.withAlphaComponent(0.15).cgColor

        bootstrapButton.addTarget(
            self,
            action: #selector(checkBootstrap),
            for: .touchUpInside
        )

        content.addSubview(bootstrapButton)

        let logsTitle = makeLabel(
            "DIAGNOSTICS",
            size: 12,
            color: .lightGray
        )

        logsTitle.frame = CGRect(
            x: 24,
            y: 490,
            width: width - 48,
            height: 22
        )

        content.addSubview(logsTitle)

        let logPanel = makePanel()

        logPanel.frame = CGRect(
            x: 20,
            y: 520,
            width: width - 40,
            height: 190
        )

        content.addSubview(logPanel)

        logsLabel.frame = CGRect(
            x: 12,
            y: 12,
            width: width - 64,
            height: 166
        )

        logsLabel.font = UIFont(
            name: "Menlo-Regular",
            size: 10
        ) ?? UIFont.systemFont(ofSize: 10)

        logsLabel.textColor = accent
        logsLabel.numberOfLines = 0

        logPanel.addSubview(logsLabel)

        scrollView.contentSize = content.frame.size
    }

    private func refreshDevice() {

        let device = DeviceInfo.current

        versionLabel.text =
            "iOS: \(device.version)"

        deviceLabel.text =
            "Device: \(device.model) · \(device.architecture)"

        statusLabel.text = device.isCompatible
            ? "VERSION AND ARCHITECTURE SUPPORTED"
            : "DEVICE OUTSIDE TARGET"
    }

    @objc private func startJailbreak() {

        jailbreakButton.isEnabled = false
        statusLabel.text = "CHECKING..."

        JailbreakCoordinator.shared.start {
            [weak self] success, message in

            guard let self = self else { return }

            self.jailbreakButton.isEnabled = true

            self.statusLabel.text = success
                ? "BACKEND OPERATION COMPLETED"
                : "JAILBREAK NOT COMPLETED"

            self.refreshLogs()

            let alert = UIAlertController(
                title: "gat0r",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                )
            )

            self.present(
                alert,
                animated: true
            )
        }
    }

    @objc private func checkBootstrap() {

        let alert = UIAlertController(
            title: "Bootstrap",
            message: "No verified bootstrap installation backend is connected.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)

        GTRLogger.shared.log(
            "Bootstrap check requested."
        )

        refreshLogs()
    }

    private func refreshLogs() {

        let logs = GTRLogger.shared.entries()

        let recent = Array(logs.suffix(9))

        logsLabel.text = recent.joined(
            separator: "\n"
        )
    }
}
