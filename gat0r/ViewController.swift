import UIKit

final class ViewController: UIViewController {

    private let ink = UIColor(red: 0.055, green: 0.071, blue: 0.055, alpha: 1)
    private let paper = UIColor(red: 0.91, green: 0.91, blue: 0.82, alpha: 1)
    private let dim = UIColor(red: 0.48, green: 0.52, blue: 0.43, alpha: 1)
    private let acid = UIColor(red: 0.76, green: 0.91, blue: 0.34, alpha: 1)
    private let rule = UIColor(red: 0.22, green: 0.27, blue: 0.20, alpha: 1)

    private let scrollView = UIScrollView()
    private let content = UIView()
    private let stack = UIStackView()

    private let versionValue = UILabel()
    private let modelValue = UILabel()
    private let architectureValue = UILabel()
    private let compatibilityValue = UILabel()
    private let statusValue = UILabel()
    private let statusMark = UIView()
    private let logsValue = UILabel()
    private let jailbreakButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ink

        configureLayout()
        refreshDevice()

        GTRLogger.shared.log("gat0r / session opened")
        refreshLogs()
    }

    private func configureLayout() {
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

        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)

        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false

        content.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 25),
            stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -25),
            stack.topAnchor.constraint(equalTo: content.topAnchor, constant: 25),
            stack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -32)
        ])

        buildMasthead()
        buildHero()
        buildDeviceSection()
        buildActionSection()
        buildDiagnosticsSection()
    }

    private func mono(_ size: CGFloat, bold: Bool = false) -> UIFont {
        let name = bold ? "Menlo-Bold" : "Menlo-Regular"

        return UIFont(name: name, size: size)
            ?? UIFont.systemFont(ofSize: size, weight: bold ? .bold : .regular)
    }

    private func label(
        _ text: String,
        size: CGFloat,
        color: UIColor,
        weight: UIFont.Weight = .regular
    ) -> UILabel {
        let item = UILabel()

        item.text = text
        item.textColor = color
        item.font = UIFont.systemFont(ofSize: size, weight: weight)
        item.numberOfLines = 0

        return item
    }

    private func addRule() {
        let line = UIView()

        line.backgroundColor = rule
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(
            equalToConstant: 1 / UIScreen.main.scale
        ).isActive = true

        stack.addArrangedSubview(line)
    }

    private func buildMasthead() {
        let row = UIStackView()

        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .equalSpacing

        let mark = label("G / 01", size: 11, color: acid, weight: .bold)
        mark.font = mono(11, bold: true)

        let edition = label("FIELD RELEASE     •     ARM64", size: 9, color: dim)
        edition.font = mono(9)

        row.addArrangedSubview(mark)
        row.addArrangedSubview(edition)

        stack.addArrangedSubview(row)
        stack.setCustomSpacing(34, after: row)

        addRule()
        stack.setCustomSpacing(21, after: stack.arrangedSubviews.last!)
    }

    private func buildHero() {
        let title = label("gat0r", size: 58, color: paper, weight: .bold)

        title.font = UIFont(name: "Georgia-Bold", size: 58)
            ?? UIFont.boldSystemFont(ofSize: 58)

        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.7

        stack.addArrangedSubview(title)
        stack.setCustomSpacing(3, after: title)

        let subtitle = label(
            "A rootful instrument for iOS 11.",
            size: 14,
            color: dim
        )

        subtitle.font = UIFont(name: "Georgia", size: 14)
            ?? UIFont.systemFont(ofSize: 14)

        stack.addArrangedSubview(subtitle)
        stack.setCustomSpacing(24, after: subtitle)

        let target = UIStackView()

        target.axis = .horizontal
        target.alignment = .center
        target.spacing = 10

        let targetMark = UIView()
        targetMark.backgroundColor = acid
        targetMark.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            targetMark.widthAnchor.constraint(equalToConstant: 5),
            targetMark.heightAnchor.constraint(equalToConstant: 22)
        ])

        let targetText = label(
            "TARGET WINDOW   /   11.0 — 11.4.1",
            size: 10,
            color: acid
        )

        targetText.font = mono(10, bold: true)

        target.addArrangedSubview(targetMark)
        target.addArrangedSubview(targetText)

        stack.addArrangedSubview(target)
        stack.setCustomSpacing(29, after: target)
    }

    private func buildDeviceSection() {
        addRule()
        stack.setCustomSpacing(17, after: stack.arrangedSubviews.last!)

        addSectionHeading("01", title: "DEVICE RECORD")

        addDataRow("SYSTEM", value: versionValue)
        addDataRow("IDENTIFIER", value: modelValue)
        addDataRow("ARCHITECTURE", value: architectureValue)

        compatibilityValue.font = mono(9, bold: true)
        compatibilityValue.textColor = acid
        compatibilityValue.numberOfLines = 0

        stack.addArrangedSubview(compatibilityValue)
        stack.setCustomSpacing(22, after: compatibilityValue)
    }

    private func buildActionSection() {
        addRule()
        stack.setCustomSpacing(17, after: stack.arrangedSubviews.last!)

        addSectionHeading("02", title: "EXECUTION")

        let statusRow = UIStackView()

        statusRow.axis = .horizontal
        statusRow.alignment = .center
        statusRow.spacing = 9

        statusMark.backgroundColor = acid
        statusMark.layer.cornerRadius = 2
        statusMark.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusMark.widthAnchor.constraint(equalToConstant: 5),
            statusMark.heightAnchor.constraint(equalToConstant: 5)
        ])

        statusValue.text = "BACKEND NOT VERIFIED"
        statusValue.textColor = paper
        statusValue.font = mono(10, bold: true)

        statusRow.addArrangedSubview(statusMark)
        statusRow.addArrangedSubview(statusValue)

        stack.addArrangedSubview(statusRow)
        stack.setCustomSpacing(15, after: statusRow)

        jailbreakButton.setTitle("  JAILBREAK  ↗", for: .normal)
        jailbreakButton.setTitleColor(ink, for: .normal)
        jailbreakButton.titleLabel?.font = mono(13, bold: true)
        jailbreakButton.contentHorizontalAlignment = .left
        jailbreakButton.backgroundColor = acid
        jailbreakButton.layer.cornerRadius = 2
        jailbreakButton.contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 17,
            bottom: 0,
            right: 17
        )

        jailbreakButton.translatesAutoresizingMaskIntoConstraints = false
        jailbreakButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

        jailbreakButton.addTarget(
            self,
            action: #selector(startJailbreak),
            for: .touchUpInside
        )

        stack.addArrangedSubview(jailbreakButton)
        stack.setCustomSpacing(8, after: jailbreakButton)

        let bootstrap = UIButton(type: .system)

        bootstrap.setTitle("INSPECT BOOTSTRAP  →", for: .normal)
        bootstrap.setTitleColor(dim, for: .normal)
        bootstrap.contentHorizontalAlignment = .left
        bootstrap.titleLabel?.font = mono(9, bold: true)
        bootstrap.addTarget(
            self,
            action: #selector(checkBootstrap),
            for: .touchUpInside
        )

        bootstrap.heightAnchor.constraint(equalToConstant: 36).isActive = true

        stack.addArrangedSubview(bootstrap)
        stack.setCustomSpacing(24, after: bootstrap)
    }

    private func buildDiagnosticsSection() {
        addRule()
        stack.setCustomSpacing(17, after: stack.arrangedSubviews.last!)

        addSectionHeading("03", title: "EVENT TRACE")

        logsValue.font = mono(9)
        logsValue.textColor = UIColor(
            red: 0.66,
            green: 0.70,
            blue: 0.59,
            alpha: 1
        )
        logsValue.numberOfLines = 0
        logsValue.lineBreakMode = .byWordWrapping

        let logPanel = UIView()

        logPanel.backgroundColor = UIColor(
            red: 0.08,
            green: 0.10,
            blue: 0.075,
            alpha: 1
        )

        logPanel.layer.borderWidth = 1
        logPanel.layer.borderColor = rule.cgColor
        logPanel.layer.cornerRadius = 2
        logPanel.translatesAutoresizingMaskIntoConstraints = false

        logPanel.addSubview(logsValue)
        logsValue.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logsValue.leadingAnchor.constraint(equalTo: logPanel.leadingAnchor, constant: 12),
            logsValue.trailingAnchor.constraint(equalTo: logPanel.trailingAnchor, constant: -12),
            logsValue.topAnchor.constraint(equalTo: logPanel.topAnchor, constant: 12),
            logsValue.bottomAnchor.constraint(equalTo: logPanel.bottomAnchor, constant: -12),
            logPanel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])

        stack.addArrangedSubview(logPanel)
        stack.setCustomSpacing(17, after: logPanel)

        let footer = label(
            "GAT0R     /     EXPERIMENTAL SOFTWARE     /     NO WARRANTY",
            size: 8,
            color: dim
        )

        footer.font = mono(8)
        footer.textAlignment = .center

        stack.addArrangedSubview(footer)
    }

    private func addSectionHeading(_ number: String, title: String) {
        let row = UIStackView()

        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12

        let index = label(number, size: 10, color: acid, weight: .bold)
        index.font = mono(10, bold: true)

        let heading = label(title, size: 10, color: paper, weight: .bold)
        heading.font = mono(10, bold: true)

        row.addArrangedSubview(index)
        row.addArrangedSubview(heading)

        stack.addArrangedSubview(row)
        stack.setCustomSpacing(15, after: row)
    }

    private func addDataRow(_ title: String, value: UILabel) {
        let row = UIStackView()

        row.axis = .horizontal
        row.alignment = .firstBaseline
        row.spacing = 12

        let key = label(title, size: 9, color: dim)
        key.font = mono(9)
        key.setContentHuggingPriority(.required, for: .horizontal)
        key.widthAnchor.constraint(equalToConstant: 105).isActive = true

        value.textColor = paper
        value.font = mono(10)
        value.textAlignment = .right
        value.numberOfLines = 2
        value.lineBreakMode = .byTruncatingMiddle

        row.addArrangedSubview(key)
        row.addArrangedSubview(value)

        stack.addArrangedSubview(row)
        stack.setCustomSpacing(10, after: row)
    }

    private func refreshDevice() {
        let device = DeviceInfo.current

        versionValue.text = "iOS " + device.version
        modelValue.text = device.model
        architectureValue.text = device.architecture

        compatibilityValue.text = device.isCompatible
            ? "TARGET MATCHED  /  VERSION + ARCHITECTURE"
            : "OUT OF RANGE  /  " + device.compatibilityReason.uppercased()

        statusValue.text = device.isCompatible
            ? "TARGET DEVICE DETECTED"
            : "DEVICE OUTSIDE TARGET"

        statusMark.backgroundColor = device.isCompatible
            ? acid
            : UIColor(red: 0.88, green: 0.49, blue: 0.30, alpha: 1)
    }

    @objc private func startJailbreak() {
        jailbreakButton.isEnabled = false
        jailbreakButton.alpha = 0.55

        statusValue.text = "CHECKING BACKEND…"
        statusMark.backgroundColor = acid

        JailbreakCoordinator.shared.start {
            [weak self] (success: Bool, message: String) in

            guard let self = self else { return }

            self.jailbreakButton.isEnabled = true
            self.jailbreakButton.alpha = 1

            self.statusValue.text = success
                ? "COMPLETED"
                : "BACKEND UNAVAILABLE"

            self.statusMark.backgroundColor = success
                ? self.acid
                : UIColor(red: 0.88, green: 0.49, blue: 0.30, alpha: 1)

            self.refreshLogs()

            let alert = UIAlertController(
                title: "gat0r",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(title: "CLOSE", style: .default)
            )

            self.present(alert, animated: true)
        }
    }

    @objc private func checkBootstrap() {
        let message = "No verified bootstrap installer is connected to this build."

        GTRLogger.shared.log(
            "Bootstrap inspection requested; installer unavailable."
        )

        refreshLogs()

        let alert = UIAlertController(
            title: "BOOTSTRAP",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "CLOSE", style: .default)
        )

        present(alert, animated: true)
    }

    private func refreshLogs() {
        let entries = GTRLogger.shared.entries()

        logsValue.text = entries.isEmpty
            ? "No events recorded."
            : entries.suffix(7).joined(separator: "\n")
    }
}
