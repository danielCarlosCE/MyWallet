import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    private let addExpenseId = "addExpense"
    private let addCreditId = "addCredit"
    
    var viewModel: WalletViewModelType = WalletViewModel()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        changeBalance(with: viewModel.wallet)
        viewModel.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let next = segue.destination as? TransactionInputViewController else { return }
        
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

extension WalletViewController: ViewModelDelegate {
    func walletDiChange(newValue wallet: Wallet) {
        changeBalance(with: wallet)
    }
    
    fileprivate func changeBalance(with wallet: Wallet) {
        balanceLabel.text = wallet.balance
        balanceLabel.textColor = wallet.status.color
    }
}

private extension Wallet.Status {
    var color: UIColor {
        switch self {
        case .negative:
            return .red
        case .positive:
            return .green
        }
    }
}

