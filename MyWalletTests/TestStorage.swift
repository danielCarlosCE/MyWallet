@testable import MyWallet

class TestStorage: Storage {
    private(set) var wallet = WalletModel(balance: 0)
    var addedValue: Double = 0
    var completion: (([Entry]) -> Void)?
    
    func add(value: Double) {
        addedValue = value
        wallet.balance += value
    }
    
    func loadHistory(completion: @escaping ([Entry]) -> Void) {
        self.completion = completion
    }
}
