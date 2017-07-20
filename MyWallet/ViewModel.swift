import Foundation

protocol ViewModelDelegate: class {
    func walletDiChange(newValue wallet: WalletViewModel)
}

protocol ViewModelType {
    var delegate: ViewModelDelegate? {get set}
    var wallet: WalletViewModel {get}

    func addExpense(_ value: Double)
    func addCredit(_ value: Double)
}

class ViewModel: ViewModelType {
    
    weak var delegate: ViewModelDelegate?
    
    private(set) var wallet: WalletViewModel {
        didSet {
            delegate?.walletDiChange(newValue: wallet)
        }
    }
    
    private let storage: Storage
    
    init(storage: Storage = LocalStorage.shared) {
        self.storage = storage
        wallet = WalletViewModel(balance: ViewModel.balanceValue(for: storage.wallet.balance), status: .positive)
    }
    
    func addExpense(_ value: Double) {
        let negativeValue = value < 0 ? value : -value
        storage.add(value: negativeValue)
        updateWallet(from: storage.wallet)
    }
    
    func addCredit(_ value: Double) {
        let positiveValue = value < 0 ? -value : value
        storage.add(value: positiveValue)
        updateWallet(from: storage.wallet)
    }
    
    private func updateWallet(from wallet: Wallet) {
        self.wallet.balance = ViewModel.balanceValue(for: storage.wallet.balance)
        self.wallet.status = (wallet.balance >= 0) ? .positive : .negative
    }
    
    private static func balanceValue(for balance: Double) -> String {
         return NumberFormatter.localizedString(from: NSNumber(value: balance), number: .currency)
    }
    
}

struct WalletViewModel {
    enum Status {
        case negative
        case positive
    }
    
    var balance: String
    var status: Status
}

extension WalletViewModel: Equatable {
    public static func ==(lhs: WalletViewModel, rhs: WalletViewModel) -> Bool {
        return lhs.balance == rhs.balance && lhs.status == rhs.status
    }
}
