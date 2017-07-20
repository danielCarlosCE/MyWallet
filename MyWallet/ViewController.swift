import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    private let addExpenseId = "addExpense"
    private let addCreditId = "addCredit"
    
    var viewModel: ViewModelType = ViewModel()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        changeBalance(with: viewModel.wallet)
        viewModel.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let next = segue.destination as? ViewController2 else { return }
        
        if segue.identifier == addExpenseId {
            next.type = .expense
            next.completion = { [weak self] value in
                self?.viewModel.addExpense(value)
            }
        }
        
        if segue.identifier == addCreditId {
            next.type = .credit
            next.completion = { [weak self] value in
                self?.viewModel.addCredit(value)
            }
        }
    }
    
    @IBAction func addExpense() {
        performSegue(withIdentifier: addExpenseId, sender: nil)
    }
    
    @IBAction func addCredit() {
        performSegue(withIdentifier: addCreditId, sender: nil)
    }


}

extension ViewController: ViewModelDelegate {
    func walletDiChange(newValue wallet: WalletViewModel) {
        changeBalance(with: wallet)
    }
    
    fileprivate func changeBalance(with wallet: WalletViewModel) {
        balanceLabel.text = wallet.balance
        balanceLabel.textColor = wallet.status.color
    }
}

private extension WalletViewModel.Status {
    var color: UIColor {
        switch self {
        case .negative:
            return .red
        case .positive:
            return .green
        }
    }
}

