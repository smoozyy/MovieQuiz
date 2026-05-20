import UIKit

final class AlertPresenter {
    func show(in vc: UIViewController, model: AlertModel, accessibilityId: String ) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = accessibilityId
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
