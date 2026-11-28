
import UIKit

final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let iosBackground = UIColor(
        red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0
    )
    private let iosBlue = UIColor(
        red: 0.00, green: 0.48, blue: 1.00, alpha: 1.0
    )
    private let primaryText = UIColor(
        red: 0.12, green: 0.12, blue: 0.13, alpha: 1.0
    )
    private let secondaryText = UIColor(
        red: 0.48, green: 0.48, blue: 0.50, alpha: 1.0
    )

    private var device = DeviceInfo.current
    private var isStartingJailbreak = false

    private func helvetica(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)
            ?? UIFont.systemFont(ofSize: size)
    }

    private func light(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size)
            ?? helvetica(size)
    }

    private func ultraLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-UltraLight", size: size)
            ?? light(size)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = iosBackground
        configureNavigationBar()
        configureTableView()

        GTRLogger.shared.log("gat0r / session opened")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        device = DeviceInfo.current
        tableView.reloadData()
    }

    private func configureNavigationBar() {
        title = "gat0r"

        let bar = navigationController?.navigationBar
        bar?.isHidden = false
        bar?.barStyle = .default
        bar?.isTranslucent = true
        bar?.barTintColor = UIColor.white
        bar?.tintColor = iosBlue
        bar?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: primaryText,
            NSAttributedString.Key.font: light(17)
        ]
        bar?.shadowImage = UIImage()
        bar?.setBackgroundImage(UIImage(), for: .default)
    }

    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = iosBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor(
            red: 0.82, green: 0.82, blue: 0.84, alpha: 1
        )
        tableView.separatorInset = UIEdgeInsets(
            top: 0, left: 15, bottom: 0, right: 0
        )
        tableView.rowHeight = 56
        tableView.estimatedRowHeight = 56
        tableView.tableFooterView = makeFooter()

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.tableHeaderView = makeHeader()
    }

    private func makeHeader() -> UIView {
        let header = UIView(
            frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 174)
        )
        header.backgroundColor = iosBackground

        let titleLabel = UILabel()
        titleLabel.text = "gat0r"
        titleLabel.font = ultraLight(48)
        titleLabel.textColor = primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitle = UILabel()
        subtitle.text = "A jailbreak for the rest of us."
        subtitle.font = light(17)
        subtitle.textColor = secondaryText
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        let version = UILabel()
        version.text = "iOS 11  ·  EXPERIMENTAL"
        version.font = helvetica(10)
        version.textColor = iosBlue
        version.translatesAutoresizingMaskIntoConstraints = false

        header.addSubview(titleLabel)
        header.addSubview(subtitle)
        header.addSubview(version)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -1),

            subtitle.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitle.bottomAnchor.constraint(equalTo: version.topAnchor, constant: -13),

            version.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            version.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -22)
        ])

        return header
    }

    private func makeFooter() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 54))

        let label = UILabel()
        label.text = "gat0r  •  Made for iOS 11"
        label.font = light(12)
        label.textColor = secondaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        footer.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: footer.centerYAnchor)
        ])

        return footer
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 3
        case 3: return 1
        default: return 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch section {
        case 0: return "JAILBREAK"
        case 1: return "DEVICE"
        case 2: return "TOOLS"
        case 3: return "RECENT ACTIVITY"
        default: return nil
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let identifier = "gat0r.cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)

        cell.backgroundColor = .white
        cell.selectionStyle = .default
        cell.accessoryType = .none
        cell.accessoryView = nil
        cell.textLabel?.font = light(16)
        cell.textLabel?.textColor = primaryText
        cell.detailTextLabel?.font = light(12)
        cell.detailTextLabel?.textColor = secondaryText
        cell.detailTextLabel?.numberOfLines = 0
        cell.imageView?.image = nil

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = isStartingJailbreak
                ? "Starting…"
                : "Not Jailbroken"
            cell.detailTextLabel?.text = isStartingJailbreak
                ? "Checking exploit backend"
                : "Exploit backend is not connected"
            cell.imageView?.image = statusImage()
            cell.selectionStyle = .none

        case 1:
            cell.accessoryType = .none
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "iOS Version"
                cell.detailTextLabel?.text = "iOS " + device.version
            case 1:
                cell.textLabel?.text = "Device"
                cell.detailTextLabel?.text = device.model
            default:
                cell.textLabel?.text = "Architecture"
                cell.detailTextLabel?.text = device.architecture
            }
            cell.selectionStyle = .none

        case 2:
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = nil
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Jailbreak"
                cell.textLabel?.textColor = iosBlue
                cell.imageView?.image = symbolImage("bolt.fill", fallback: "↯")
            case 1:
                cell.textLabel?.text = "Inspect Bootstrap"
                cell.imageView?.image = symbolImage("shippingbox", fallback: "▣")
            default:
                cell.textLabel?.text = "System Diagnostics"
                cell.imageView?.image = symbolImage("info.circle", fallback: "ⓘ")
            }

        case 3:
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = recentActivity()
            cell.detailTextLabel?.font = UIFont(name: "Menlo", size: 10)
                ?? light(11)
            cell.detailTextLabel?.textColor = secondaryText
            cell.detailTextLabel?.numberOfLines = 6
            cell.selectionStyle = .none

        default:
            break
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if indexPath.section == 3 {
            return UITableView.automaticDimension
        }
        if indexPath.section == 0 {
            return 66
        }
        return 54
    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return indexPath.section == 3 ? 110 : 56
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard indexPath.section == 2 else { return }

        switch indexPath.row {
        case 0:
            startJailbreak()
        case 1:
            checkBootstrap()
        default:
            openDiagnostics()
        }
    }

    private func statusImage() -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "circle.fill")?
                .withTintColor(UIColor(
                    red: 0.95, green: 0.62, blue: 0.20, alpha: 1
                ), renderingMode: .alwaysOriginal)
        }
        return symbolImage(nil, fallback: "●")
    }

    private func symbolImage(_ name: String?, fallback: String) -> UIImage? {
        if #available(iOS 13.0, *), let name = name,
           let image = UIImage(systemName: name) {
            return image.withTintColor(iosBlue, renderingMode: .alwaysOriginal)
        }

        let label = UILabel()
        label.text = fallback
        label.font = light(19)
        label.textColor = iosBlue
        label.sizeToFit()

        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: 28, height: 28), false, 0
        )
        defer { UIGraphicsEndImageContext() }

        label.drawText(in: CGRect(x: 0, y: 0, width: 28, height: 28))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private func recentActivity() -> String {
        let entries = GTRLogger.shared.entries()
        if entries.isEmpty {
            return "No activity recorded."
        }
        return entries.suffix(6).joined(separator: "\n")
    }

    private func refreshScreen() {
        device = DeviceInfo.current
        tableView.reloadData()
    }

    private func startJailbreak() {
        guard !isStartingJailbreak else { return }

        isStartingJailbreak = true
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        tableView.reloadRows(
            at: [IndexPath(row: 0, section: 2)],
            with: .none
        )

        JailbreakCoordinator.shared.start { [weak self] (success: Bool, message: String) in
            guard let self = self else { return }

            self.isStartingJailbreak = false
            GTRLogger.shared.log(success
                ? "Jailbreak operation completed."
                : "Jailbreak backend unavailable.")
            self.refreshScreen()

            let alert = UIAlertController(
                title: "gat0r",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    private func checkBootstrap() {
        GTRLogger.shared.log(
            "Bootstrap inspection requested; installer unavailable."
        )
        refreshScreen()

        let alert = UIAlertController(
            title: "Bootstrap",
            message: "No verified bootstrap installer is connected to this build.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func openDiagnostics() {
        GTRLogger.shared.log("System diagnostics opened.")
        refreshScreen()

        let diagnostics = DiagnosticsViewController()
        let navigation = UINavigationController(rootViewController: diagnostics)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }
}
