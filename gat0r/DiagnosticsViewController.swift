import UIKit

final class DiagnosticsViewController: UIViewController {

    private let backgroundColorValue = UIColor(
        red: 0.035,
        green: 0.055,
        blue: 0.045,
        alpha: 1
    )

    private let accentColor = UIColor(
        red: 0.72,
        green: 0.91,
        blue: 0.36,
        alpha: 1
    )

    private let reportView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColorValue
        title = "SYSTEM REPORT"

        configureNavigation()
        configureReport()
        configureFooter()
    }

    private func configureNavigation() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = accentColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: accentColor,
            NSAttributedStringKey.font: UIFont.systemFont(
                ofSize: 12,
                weight: .bold
            )
        ]

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "COPY",
            style: .plain,
            target: self,
            action: #selector(copyReport)
        )
    }

    private func configureReport() {
        reportView.translatesAutoresizingMaskIntoConstraints = false
        reportView.backgroundColor = .clear
        reportView.textColor = UIColor(
            red: 0.78,
            green: 0.83,
            blue: 0.76,
            alpha: 1
        )
        reportView.font = UIFont.monospacedSystemFont(
            ofSize: 12,
            weight: .regular
        )
        reportView.isEditable = false
        reportView.isSelectable = true
        reportView.text = Gat0rDiagnostics.generateReport()
        reportView.textContainerInset = UIEdgeInsets(
            top: 24,
            left: 18,
            bottom: 24,
            right: 18
        )

        view.addSubview(reportView)

        NSLayoutConstraint.activate([
            reportView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            reportView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            reportView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            reportView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }

    private func configureFooter() {
        let footer = UILabel()
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.text = "GAT0R  /  READ-ONLY DIAGNOSTICS"
        footer.textColor = accentColor
        footer.font = UIFont.monospacedSystemFont(
            ofSize: 9,
            weight: .bold
        )
        footer.textAlignment = .center

        view.addSubview(footer)

        NSLayoutConstraint.activate([
            footer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -8
            ),
            footer.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            )
        ])
    }

    @objc private func copyReport() {
        UIPasteboard.general.string = reportView.text

        let alert = UIAlertController(
            title: "REPORT COPIED",
            message: "The diagnostics report is on your clipboard.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }
}
