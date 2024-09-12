import UIKit

private enum Notification: String {
    case increase = "значение изменено на +1"
    case decrease = "значение изменено на -1"
    case reset = "значение сброшено"
    case lessZero = "попытка уменьшить значение счётчика ниже 0"
}

final class CounterViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var historyTextView: UITextView!
    
    // MARK: - Private Properties
    private var counter: Int = 0 {
        didSet {
            if counter < 0 {
                counter = 0
            } else {
                counterLabel.text = String(counter)
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return date
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - IB Actions
    @IBAction private func increaseByOne(_ sender: UIButton) {
        counter += 1
        historyTextViewPerform(notification: .increase)
    }
    
    @IBAction private func decreaseByOne(_ sender: UIButton) {
        let decreaseOrToZero = counter > 0 ? Notification.decrease : Notification.lessZero
        counter -= 1
        historyTextViewPerform(notification: decreaseOrToZero)
    }
    
    @IBAction private func resetToZero(_ sender: UIButton) {
        counter = 0
        historyTextViewPerform(notification: .reset)
    }
    
    // MARK: - Private Methods
    
    private func configure() {
        [
            plusButton,
            minusButton,
            resetButton
        ].forEach { button in
            button.layer.cornerRadius = (button.frame.size.width) / 2
        }
        historyTextView.layer.cornerRadius = 8
        historyTextView.isEditable = false
        historyTextView.isSelectable = false
    }
    
    private func historyTextViewPerform(notification: Notification) {
        notificationOfChange(text: notification)
        historyTextView.scrollHistoryTextView()
    }
    
    private func notificationOfChange(text: Notification) {
        let currentDateTime = Date()
        historyTextView.text += "[\(dateFormatter.string(from: currentDateTime))]:" + text.rawValue + "\n"
    }
}

private extension UITextView {
    func scrollHistoryTextView() {
        let range = NSMakeRange(self.text.count - 1, 0)
        self.scrollRangeToVisible(range)
    }
}

