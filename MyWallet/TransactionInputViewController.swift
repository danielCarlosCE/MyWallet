import UIKit

class TransactionInputViewController: UIViewController {

    @IBOutlet weak var inputType: UILabel!
    @IBOutlet weak var input: UITextField!
    
    enum InputType {
        case expense
        case credit
    }
    
    var type: InputType = .expense
    var completion: ((Double) -> Void)?
    
    override func viewDidLoad() {
        addToolBar(to: input)
        changeTitle(from: type)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        input.becomeFirstResponder()
    }
    
    func cancel() {
        input.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    func done() {
        guard let inputText = input.text, let value = Double(inputText) else { return }
        
        input.endEditing(true)
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(value)
        })
    }
    
    private func addToolBar(to input: UITextField) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        let flexibeSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        
        toolbar.items = [cancelBtn, flexibeSpace, doneBtn]
        
        input.inputAccessoryView = toolbar
    }
    
    private func changeTitle(from type: InputType) {
        switch type {
        case .expense:
            inputType.text = NSLocalizedString("Expense", comment: "Type of input")
        case .credit:
            inputType.text = NSLocalizedString("Credit", comment: "Type of input")
        }
    }
    
    
}
