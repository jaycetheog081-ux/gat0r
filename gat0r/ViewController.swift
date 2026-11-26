import UIKit

final class ViewController: UIViewController {

    private let backgroundTop = UIColor(
        red: 0.075,
        green: 0.065,
        blue: 0.105,
        alpha: 1
    )

    private let backgroundBottom = UIColor(
        red: 0.025,
        green: 0.027,
        blue: 0.040,
        alpha: 1
    )

    private let accent = UIColor(
        red: 0.72,
        green: 0.57,
        blue: 0.91,
        alpha: 1
    )

    private let mutedText = UIColor(
        red: 0.62,
        green: 0.60,
        blue: 0.68,
        alpha: 1
    )

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainStack = UIStackView()

    private let versionLabel = UILabel()
    private let deviceLabel = UILabel()
    private let architectureLabel = UILabel()
    private let compatibilityLabel = UILabel()
    private let statusLabel = UILabel()
    private let statusIndicator = UIView()
    private let logsLabel = UILabel()

    private let jailbreakButton = UIButton(type: .system)
    private let bootstrapButton = UIButton(type: .system)

    private let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundBottom
        configureBackground()
        buildInterface()

        refreshDevice()
        GTRLogger.shared.log("gat0r initialized.")
        refreshLogs()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    private func configureBackground() {
        gradientLayer.colors = [
            backgroundTop.cgColor,
            backgroundBottom.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.15, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.85, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func makeLabel(
        _ text: String,
        size: CGFloat,
        weight: UIFont.Weight = .regular,
        color: UIColor = .white
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.numberOfLines = 0
        return label
    }

    private func makeRule() -> UIView {
        let rule = UIView()
        rule.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        rule.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return rule
    }

    private func buildInterface() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.spacing = 0
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])

        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        let wordmark = makeLabel(
            "gat0r",
            size: 39,
            weight: .bold,
            color: UIColor(red: 0.91, green: 0.87, blue: 0.97, alpha: 1)
        )
        wordmark.translatesAutoresizingMaskIntoConstraints = false

        let subtitle = makeLabel(
            "A ROOTFUL iOS 11 JAILBREAK",
            size: 10,
            weight: .semibold,
            color: mutedText
        )
        subtitle.font = UIFont(name: "Menlo-Bold", size: 9) ?? UIFont.systemFont(ofSize: 9, weight: .semibold)
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        header.addSubview(wordmark)
        header.addSubview(subtitle)

        NSLayoutConstraint.activate([
            wordmark.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            wordmark.topAnchor.constraint(equalTo: header.topAnchor),
            subtitle.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 2),
            subtitle.topAnchor.constraint(equalTo: wordmark.bottomAnchor, constant: 3),
            subtitle.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            header.heightAnchor.constraint(equalToConstant: 76)
        ])

        mainStack.addArrangedSubview(header)
        mainStack.setCustomSpacing(28, after: header)

        let targetLine = makeLabel(
            "TARGET  /  11.0 — 11.4.1",
            size: 10,
            weight: .medium,
            color: accent
        )
        targetLine.font = UIFont(name: "Menlo-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        mainStack.addArrangedSubview(targetLine)
        mainStack.setCustomSpacing(13, after: targetLine)

        mainStack.addArrangedSubview(makeRule())
        mainStack.setCustomSpacing(17, after: mainStack.arrangedSubviews.last!)

        let deviceHeading = makeLabel(
            "DEVICE",
            size: 10,
            weight: .bold,
            color: mutedText
        )
        deviceHeading.font = UIFont(name: "Menlo-Bold", size: 9) ?? UIFont.systemFont(ofSize: 9, weight: .bold)
        mainStack.addArrangedSubview(deviceHeading)
        mainStack.setCustomSpacing(10, after: deviceHeading)

        versionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        versionLabel.textColor = .white
        mainStack.addArrangedSubview(versionLabel)
        mainStack.setCustomSpacing(5, after: versionLabel)

        deviceLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        deviceLabel.textColor = mutedText
        mainStack.addArrangedSubview(deviceLabel)
        mainStack.setCustomSpacing(4, after: deviceLabel)

        architectureLabel.font = UIFont(name: "Menlo-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        architectureLabel.textColor = mutedText
        mainStack.addArrangedSubview(architectureLabel)
        mainStack.setCustomSpacing(8, after: architectureLabel)

        compatibilityLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        compatibilityLabel.textColor = accent
        mainStack.addArrangedSubview(compatibilityLabel)
        mainStack.setCustomSpacing(20, after: compatibilityLabel)

        let statusRow = UIStackView()
        statusRow.axis = .horizontal
        statusRow.alignment = .center
        statusRow.spacing = 9

        statusIndicator.backgroundColor = UIColor(
            red: 0.78,
            green: 0.59,
            blue: 0.36,
            alpha: 1
        )
        statusIndicator.layer.cornerRadius = 3
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusIndicator.widthAnchor.constraint(equalToConstant: 6),
            statusIndicator.heightAnchor.constraint(equalToConstant: 6)
        ])

        statusLabel.text = "READY"
        statusLabel.font = UIFont(name: "Menlo-Bold", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        statusLabel.textColor = mutedText

        statusRow.addArrangedSubview(statusIndicator)
        statusRow.addArrangedSubview(statusLabel)
        mainStack.addArrangedSubview(statusRow)
        mainStack.setCustomSpacing(17, after: statusRow)

        jailbreakButton.backgroundColor = UIColor(
            red: 0.43,
            green: 0.31,
            blue: 0.58,
            alpha: 1
        )
        jailbreakButton.setTitle("JAILBREAK", for: .normal)
        jailbreakButton.setTitleColor(.white, for: .normal)
        jailbreakButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        jailbreakButton.layer.cornerRadius = 8
        jailbreakButton.layer.borderWidth = 1
        jailbreakButton.layer.borderColor = UIColor.white.withAlphaComponent(0.13).cgColor
        jailbreakButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        jailbreakButton.addTarget(
            self,
            action: #selector(startJailbreak),
            for: .touchUpInside
        )
        mainStack.addArrangedSubview(jailbreakButton)
        mainStack.setCustomSpacing(9, after: jailbreakButton)

        bootstrapButton.setTitle("CHECK BOOTSTRAP", for: .normal)
        bootstrapButton.setTitleColor(mutedText, for: .normal)
        bootstrapButton.titleLabel?.font = UIFont(name: "Menlo-Bold", size: 9) ?? UIFont.systemFont(ofSize: 9, weight: .bold)
        bootstrapButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        bootstrapButton.addTarget(
            self,
            action: #selector(checkBootstrap),
            for: .touchUpInside
        )
        mainStack.addArrangedSubview(bootstrapButton)
        mainStack.setCustomSpacing(24, after: bootstrapButton)

        mainStack.addArrangedSubview(makeRule())
        mainStack.setCustomSpacing(15, after: mainStack.arrangedSubviews.last!)

        let diagnosticsHeading = makeLabel(
            "DIAGNOSTICS",
            size: 10,
            weight: .bold,
            color: mutedText
        )
        diagnosticsHeading.font = UIFont(name: "Menlo-Bold", size: 9) ?? UIFont.systemFont(ofSize: 9, weight: .bold)
        mainStack.addArrangedSubview(diagnosticsHeading)
        mainStack.setCustomSpacing(10, after: diagnosticsHeading)

        logsLabel.font = UIFont(name: "Menlo-Regular", size: 9) ?? UIFont.systemFont(ofSize: 9)
        logsLabel.textColor = UIColor(
            red: 0.72,
            green: 0.69,
            blue: 0.79,
            alpha: 1
        )
        logsLabel.numberOfLines = 0
        logsLabel.lineBreakMode = .byWordWrapping
        logsLabel.text = "Waiting for diagnostics…"

        let logContainer = UIView()
        logContainer.backgroundColor = UIColor.black.withAlphaComponent(0.20)
        logContainer.layer.cornerRadius = 5
        logContainer.layer.borderWidth = 1
        logContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.07).cgColor
        logContainer.translatesAutoresizingMaskIntoConstraints = false
        logContainer.addSubview(logsLabel)
        logsLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logsLabel.leadingAnchor.constraint(equalTo: logContainer.leadingAnchor, constant: 12),
            logsLabel.trailingAnchor.constraint(equalTo: logContainer.trailingAnchor, constant: -12),
            logsLabel.topAnchor.constraint(equalTo: logContainer.topAnchor, constant: 12),
            logsLabel.bottomAnchor.constraint(equalTo: logContainer.bottomAnchor, constant: -12),
            logContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 112)
        ])

        mainStack.addArrangedSubview(logContainer)
    }

    private func refreshDevice() {
        let device = DeviceInfo.current

        versionLabel.text = "iOS \(device.version)"
        deviceLabel.text = device.model
        architectureLabel.text = "ARCH  /  \(device.architecture)"

        compatibilityLabel.text = device.isCompatible
            ? "TARGET VERSION DETECTED"
            : device.compatibilityReason.uppercased()

        statusLabel.text = device.isCompatible
            ? "COMPATIBLE DEVICE"
            : "OUTSIDE SUPPORTED TARGET"

        statusIndicator.backgroundColor = device.isCompatible
            ? UIColor(red: 0.43, green: 0.70, blue: 0.55, alpha: 1)
            : UIColor(red: 0.78, green: 0.59, blue: 0.36, alpha: 1)
    }

    @objc private func startJailbreak() {
        jailbreakButton.isEnabled = false
        jailbreakButton.alpha = 0.65
        statusLabel.text = "CHECKING DEVICE"
        statusIndicator.backgroundColor = accent

        JailbreakCoordinator.shared.start { [weak self] success, message in
            guard let self = self else { return }

            self.jailbreakButton.isEnabled = true
            self.jailbreakButton.alpha = 1

            self.statusLabel.text = success
                ? "OPERATION COMPLETED"
                : "JAILBREAK NOT COMPLETED"

            self.statusIndicator.backgroundColor = success
                ? UIColor(red: 0.43, green: 0.70, blue: 0.55, alpha: 1)
                : UIColor(red: 0.78, green: 0.59, blue: 0.36, alpha: 1)

            self.refreshLogs()

            let alert = UIAlertController(
                title: "gat0r",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(title: "OK", style: .default)
            )

            self.present(alert, animated: true)
        }
    }

    @objc private func checkBootstrap() {
        let message = "No verified bootstrap installation backend is connected."

        GTRLogger.shared.log("Bootstrap check requested.")
        refreshLogs()

        let alert = UIAlertController(
            title: "Bootstrap",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }

    private func refreshLogs() {
        let logs = GTRLogger.shared.entries()
        let recent = Array(logs.suffix(8))
        logsLabel.text = recent.isEmpty
            ? "No diagnostic entries."
            : recent.joined(separator: "\n")
    }
}
