
import UIKit

final class ViewController: UIViewController {

    private let background = UIColor(
        red: 0.94, green: 0.95, blue: 0.97, alpha: 1
    )

    private let blue = UIColor(
        red: 0.00, green: 0.48, blue: 1.00, alpha: 1
    )

    private let ink = UIColor(
        red: 0.12, green: 0.13, blue: 0.16, alpha: 1
    )

    private let secondary = UIColor(
        red: 0.48, green: 0.49, blue: 0.52, alpha: 1
    )

    private let scrollView = UIScrollView()
    private let content = UIView()
    private let stack = UIStackView()

    private let versionValue = UILabel()
    private let modelValue = UILabel()
    private let architectureValue = UILabel()
    private let compatibilityValue = UILabel()
    private let statusValue = UILabel()
    private let statusDot = UIView()
    private let logsValue = UILabel()
    private let jailbreakButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = background

        configureNavigation()
        configureLayout()
        refreshDevice()

        GTRLogger.shared.log("gat0r / session opened")
        refreshLogs()
    }

    private func configureNavigation() {
        title = "gat0r"

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = blue
        navigationController?.navigationBar.backgroundColor = background

        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: ink,
            NSAttributedStringKey.font: UIFont.systemFont(
                ofSize: 17,
                weight: .semibold
            )
        ]

        navigationController?.navigationBar.shadowImage = UIImage()
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = background
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)

        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        content.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: content.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -32)
        ])

        buildHeader()
        buildStatus()
        buildDeviceInfo()
        buildActions()
        buildLogs()
        buildFooter()
    }

    private func makeLabel(
        _ text: String,
        size: CGFloat,
        weight: UIFont.Weight = .regular,
        color: UIColor = .black
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.numberOfLines = 0
        return label
    }

    private func makeSectionTitle(_ text: String) -> UILabel {
        let label = makeLabel(
            text.uppercased(),
            size: 13,
            weight: .regular,
            color: secondary
        )
        return label
    }

    private func makePanel() -> UIView {
        let panel = UIView()
        panel.backgroundColor = UIColor.white
        panel.layer.cornerRadius = 13
        panel.layer.borderWidth = 0.5
        panel.layer.borderColor = UIColor(
            red: 0.84, green: 0.85, blue: 0.88, alpha: 1
        ).cgColor
        panel.clipsToBounds = true
        return panel
    }

    private func addDivider(to panel: UIView, after row: UIView) {
        let divider = UIView()
        divider.backgroundColor = UIColor(
            red: 0.88, green: 0.89, blue: 0.91, alpha: 1
        )
        divider.translatesAutoresizingMaskIntoConstraints = false

        panel.addSubview(divider)

        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 15),
            divider.trailingAnchor.constraint(equalTo: panel.trailingAnchor),
            divider.topAnchor.constraint(equalTo: row.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func buildHeader() {
        let header = UIView()

        let eyebrow = makeLabel(
            "A ROOTFUL JAILBREAK PROJECT",
            size: 10,
            weight: .bold,
            color: blue
        )

        let title = makeLabel(
            "Hello, gat0r.",
            size: 36,
            weight: .bold,
            color: ink
        )

        title.font = UIFont.systemFont(ofSize: 36, weight: .bold)

        let subtitle = makeLabel(
            "A fresh start for your iOS 11 device.",
            size: 15,
            color: secondary
        )

        let release = makeLabel(
            "VERSION 1.0  •  EXPERIMENTAL",
            size: 10,
            weight: .semibold,
            color: secondary
        )

        header.addSubview(eyebrow)
        header.addSubview(title)
        header.addSubview(subtitle)
        header.addSubview(release)

        [eyebrow, title, subtitle, release].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            eyebrow.topAnchor.constraint(equalTo: header.topAnchor),
            eyebrow.leadingAnchor.constraint(equalTo: header.leadingAnchor),

            title.topAnchor.constraint(equalTo: eyebrow.bottomAnchor, constant: 9),
            title.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: header.trailingAnchor),

            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            subtitle.leadingAnchor.constraint(equalTo: header.leadingAnchor),

            release.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 15),
            release.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            release.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])

        stack.addArrangedSubview(header)
    }

    private func buildStatus() {
        stack.addArrangedSubview(makeSectionTitle("Jailbreak status"))

        let panel = makePanel()

        let top = UIView()
        top.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(top)

        let icon = UIView()
        icon.backgroundColor = UIColor(
            red: 0.91, green: 0.95, blue: 1, alpha: 1
        )
        icon.layer.cornerRadius = 24
        icon.translatesAutoresizingMaskIntoConstraints = false

        let glyph = makeLabel("↯", size: 27, weight: .medium, color: blue)
        glyph.textAlignment = .center
        glyph.translatesAutoresizingMaskIntoConstraints = false

        icon.addSubview(glyph)
        top.addSubview(icon)

        let heading = makeLabel(
            "Not jailbroken",
            size: 19,
            weight: .semibold,
            color: ink
        )

        let description = makeLabel(
            "The exploit backend is not connected yet.",
            size: 13,
            color: secondary
        )

        let textStack = UIStackView(arrangedSubviews: [heading, description])
        textStack.axis = .vertical
        textStack.spacing = 5
        textStack.translatesAutoresizingMaskIntoConstraints = false

        top.addSubview(textStack)

        NSLayoutConstraint.activate([
            top.topAnchor.constraint(equalTo: panel.topAnchor, constant: 19),
            top.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 17),
            top.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -17),
            top.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -19),

            icon.leadingAnchor.constraint(equalTo: top.leadingAnchor),
            icon.centerYAnchor.constraint(equalTo: top.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 48),
            icon.heightAnchor.constraint(equalToConstant: 48),

            glyph.centerXAnchor.constraint(equalTo: icon.centerXAnchor),
            glyph.centerYAnchor.constraint(equalTo: icon.centerYAnchor),

            textStack.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 13),
            textStack.trailingAnchor.constraint(equalTo: top.trailingAnchor),
            textStack.centerYAnchor.constraint(equalTo: top.centerYAnchor)
        ])

        statusValue.text = "NOT CONNECTED"
        statusValue.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        statusValue.textColor = secondary

        statusDot.backgroundColor = UIColor(
            red: 0.95, green: 0.63, blue: 0.25, alpha: 1
        )
        statusDot.layer.cornerRadius = 4
        statusDot.translatesAutoresizingMaskIntoConstraints = false

        let statusRow = UIStackView(arrangedSubviews: [statusDot, statusValue])
        statusRow.axis = .horizontal
        statusRow.alignment = .center
        statusRow.spacing = 8

        statusDot.widthAnchor.constraint(equalToConstant: 8).isActive = true
        statusDot.heightAnchor.constraint(equalToConstant: 8).isActive = true

        panel.addSubview(statusRow)
        statusRow.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusRow.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 19),
            statusRow.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -13)
        ])

        stack.addArrangedSubview(panel)
    }

    private func buildDeviceInfo() {
        stack.addArrangedSubview(makeSectionTitle("Device information"))

        let panel = makePanel()

        let rows: [(String, UILabel)] = [
            ("iOS VERSION", versionValue),
            ("DEVICE MODEL", modelValue),
            ("ARCHITECTURE", architectureValue)
        ]

        var previous: UIView?

        for (index, item) in rows.enumerated() {
            let row = UIView()
            row.translatesAutoresizingMaskIntoConstraints = false
            panel.addSubview(row)

            let key = makeLabel(item.0, size: 11, color: secondary)
            let value = item.1

            value.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            value.textColor = ink
            value.textAlignment = .right
            value.lineBreakMode = .byTruncatingMiddle

            key.translatesAutoresizingMaskIntoConstraints = false
            value.translatesAutoresizingMaskIntoConstraints = false

            row.addSubview(key)
            row.addSubview(value)

            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15),
                row.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15),
                row.heightAnchor.constraint(equalToConstant: 52),

                key.leadingAnchor.constraint(equalTo: row.leadingAnchor),
                key.centerYAnchor.constraint(equalTo: row.centerYAnchor),

                value.trailingAnchor.constraint(equalTo: row.trailingAnchor),
                value.leadingAnchor.constraint(greaterThanOrEqualTo: key.trailingAnchor, constant: 12),
                value.centerYAnchor.constraint(equalTo: row.centerYAnchor)
            ])

            if let previous = previous {
                row.topAnchor.constraint(equalTo: previous.bottomAnchor).isActive = true
            } else {
                row.topAnchor.constraint(equalTo: panel.topAnchor).isActive = true
            }

            if index < rows.count - 1 {
                addDivider(to: panel, after: row)
            }

            previous = row
        }

        previous?.bottomAnchor.constraint(equalTo: panel.bottomAnchor).isActive = true

        let note = makeLabel(
            "TARGET: iOS 11.0 – 11.4.1",
            size: 11,
            weight: .medium,
            color: blue
        )

        stack.addArrangedSubview(panel)
        stack.addArrangedSubview(note)
    }

    private func buildActions() {
        stack.addArrangedSubview(makeSectionTitle("Actions"))

        jailbreakButton.setTitle("Jailbreak", for: .normal)
        jailbreakButton.setTitleColor(.white, for: .normal)
        jailbreakButton.titleLabel?.font = UIFont.systemFont(
            ofSize: 17,
            weight: .semibold
        )
        jailbreakButton.backgroundColor = blue
        jailbreakButton.layer.cornerRadius = 13
        jailbreakButton.layer.shadowColor = blue.cgColor
        jailbreakButton.layer.shadowOpacity = 0.17
        jailbreakButton.layer.shadowRadius = 9
        jailbreakButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        jailbreakButton.heightAnchor.constraint(equalToConstant: 54).isActive = true

        jailbreakButton.addTarget(
            self,
            action: #selector(startJailbreak),
            for: .touchUpInside
        )

        stack.addArrangedSubview(jailbreakButton)

        let bootstrap = makeActionRow(
            title: "Inspect Bootstrap",
            subtitle: "Check installation components",
            symbol: "📦",
            action: #selector(checkBootstrap)
        )

        stack.addArrangedSubview(bootstrap)

        let diagnostics = makeActionRow(
            title: "System Diagnostics",
            subtitle: "View firmware and kernel information",
            symbol: "ⓘ",
            action: #selector(openDiagnostics)
        )

        stack.addArrangedSubview(diagnostics)
    }

    private func makeActionRow(
        title: String,
        subtitle: String,
        symbol: String,
        action: Selector
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.contentHorizontalAlignment = .left
        button.heightAnchor.constraint(equalToConstant: 68).isActive = true

        let icon = makeLabel(symbol, size: 22, color: blue)
        let heading = makeLabel(title, size: 15, weight: .semibold, color: ink)
        let detail = makeLabel(subtitle, size: 11, color: secondary)

        let labels = UIStackView(arrangedSubviews: [heading, detail])
        labels.axis = .vertical
        labels.spacing = 3

        let arrow = makeLabel("›", size: 25, color: secondary)

        [icon, labels, arrow].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview($0)
        }

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 28),

            labels.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            labels.centerYAnchor.constraint(equalTo: button.centerYAnchor),

            arrow.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -17),
            arrow.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])

        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func buildLogs() {
        stack.addArrangedSubview(makeSectionTitle("Recent activity"))

        let panel = makePanel()

        logsValue.font = UIFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        logsValue.textColor = secondary
        logsValue.numberOfLines = 0

        panel.addSubview(logsValue)
        logsValue.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logsValue.topAnchor.constraint(equalTo: panel.topAnchor, constant: 15),
            logsValue.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15),
            logsValue.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15),
            logsValue.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -15)
        ])

        stack.addArrangedSubview(panel)
    }

    private func buildFooter() {
        let footer = makeLabel(
            "gat0r  •  Built for iOS 11",
            size: 11,
            color: secondary
        )

        footer.textAlignment = .center
        stack.addArrangedSubview(footer)
    }

    private func refreshDevice() {
        let device = DeviceInfo.current

        versionValue.text = "iOS " + device.version
        modelValue.text = device.model
        architectureValue.text = device.architecture

        compatibilityValue.text = device.isCompatible
            ? "TARGET MATCHED"
            : "OUT OF RANGE"

        statusValue.text = device.isCompatible
            ? "TARGET DEVICE DETECTED"
            : "DEVICE OUTSIDE TARGET"

        statusDot.backgroundColor = device.isCompatible
            ? UIColor(red: 0.25, green: 0.72, blue: 0.39, alpha: 1)
            : UIColor(red: 0.95, green: 0.63, blue: 0.25, alpha: 1)
    }

    @objc private func startJailbreak() {
        jailbreakButton.isEnabled = false
        jailbreakButton.alpha = 0.6

        statusValue.text = "CHECKING BACKEND…"

        JailbreakCoordinator.shared.start {
            [weak self] (success: Bool, message: String) in

            guard let self = self else { return }

            self.jailbreakButton.isEnabled = true
            self.jailbreakButton.alpha = 1

            self.statusValue.text = success
                ? "COMPLETED"
                : "BACKEND UNAVAILABLE"

            self.statusDot.backgroundColor = success
                ? UIColor(red: 0.25, green: 0.72, blue: 0.39, alpha: 1)
                : UIColor(red: 0.95, green: 0.63, blue: 0.25, alpha: 1)

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
        GTRLogger.shared.log(
            "Bootstrap inspection requested; installer unavailable."
        )

        refreshLogs()

        let alert = UIAlertController(
            title: "Bootstrap",
            message: "No verified bootstrap installer is connected to this build.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }

    @objc private func openDiagnostics() {
        GTRLogger.shared.log("System diagnostics opened.")
        refreshLogs()

        let diagnostics = DiagnosticsViewController()
        let navigation = UINavigationController(
            rootViewController: diagnostics
        )

        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }

    private func refreshLogs() {
        let entries = GTRLogger.shared.entries()

        logsValue.text = entries.isEmpty
            ? "No activity recorded."
            : entries.suffix(6).joined(separator: "\n")
    }
}
