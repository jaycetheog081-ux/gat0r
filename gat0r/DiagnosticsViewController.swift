import UIKit

final class DiagnosticsViewController: UIViewController {

    private let background = UIColor(
        red: 0.94,
        green: 0.95,
        blue: 0.97,
        alpha: 1
    )

    private let blue = UIColor(
        red: 0.00,
        green: 0.48,
        blue: 1.00,
        alpha: 1
    )

    private let ink = UIColor(
        red: 0.12,
        green: 0.13,
        blue: 0.16,
        alpha: 1
    )

    private let secondary = UIColor(
        red: 0.48,
        green: 0.49,
        blue: 0.52,
        alpha: 1
    )

    private let reportView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = background
        title = "Diagnostics"

        configureNavigation()
        configureReport()
        configureFooter()
    }

    private func monoFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Menlo", size: size)
            ?? UIFont.systemFont(ofSize: size)
    }

    private func configureNavigation() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = blue
        navigationController?.navigationBar.backgroundColor = background

        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ink,
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: 17,
                weight: .semibold
            )
        ]

        navigationController?.navigationBar.shadowImage = UIImage()

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(closeDiagnostics)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Copy",
            style: .plain,
            target: self,
            action: #selector(copyReport)
        )
    }

    private func configureReport() {
        reportView.translatesAutoresizingMaskIntoConstraints = false
        reportView.backgroundColor = .white
        reportView.textColor = ink
        reportView.font = monoFont(12)
        reportView.isEditable = false
        reportView.isSelectable = true
        reportView.alwaysBounceVertical = true
        reportView.layer.cornerRadius = 13
        reportView.layer.borderWidth = 0.5
        reportView.layer.borderColor = UIColor(
            red: 0.84,
            green: 0.85,
            blue: 0.88,
            alpha: 1
        ).cgColor
        reportView.text = Gat0rDiagnostics.generateReport()
        reportView.textContainerInset = UIEdgeInsets(
            top: 18,
            left: 15,
            bottom: 18,
            right: 15
        )

        view.addSubview(reportView)

        NSLayoutConstraint.activate([
            reportView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            reportView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            reportView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            )
        ])
    }

    private func configureFooter() {
        let footer = UILabel()
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.text = "GAT0R  •  READ-ONLY DIAGNOSTICS"
        footer.textColor = secondary
        footer.font = monoFont(9)
        footer.textAlignment = .center

        view.addSubview(footer)

        NSLayoutConstraint.activate([
            footer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -9
            ),
            footer.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            reportView.bottomAnchor.constraint(
                equalTo: footer.topAnchor,
                constant: -12
            )
        ])
    }

    @objc private func closeDiagnostics() {
        dismiss(animated: true)
    }

    @objc private func copyReport() {
        UIPasteboard.general.string = reportView.text

        let alert = UIAlertController(
            title: "Report copied",
            message: "The diagnostics report is now on your clipboard.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }
}
