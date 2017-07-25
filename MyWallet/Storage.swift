import Foundation

protocol Storage {
    
    var wallet: WalletModel {get}
    
    func add(value: Double)
    
    func loadHistory(completion: @escaping ([Entry]) -> Void)
    
}

struct WalletModel {
    var balance: Double
}

struct Entry: Equatable {
    var value: Double
    
    public static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.value == rhs.value
    }

}

class LocalStorage: Storage {
    private(set) var wallet = WalletModel(balance: 0)
    private var history: [Entry] = []
    
    static let shared: LocalStorage = LocalStorage()
    
    func add(value: Double) {
        wallet.balance += value
        history.append(Entry(value: value))
    }
    
    func loadHistory(completion: @escaping  ([Entry]) -> Void) {
        completion(history)
    }
}
