import Foundation

protocol TransactionViewModelType {
    func loadHistory(completion: @escaping ([EntryViewModel]) -> Void)
}

class TransactionViewModel: TransactionViewModelType {
    let storage: Storage
    
    init(storage: Storage = LocalStorage.shared) {
        self.storage = storage
    }
    
    func loadHistory(completion: @escaping ([EntryViewModel]) -> Void) {
        storage.loadHistory { history in
            let historyViewModel = history.map { EntryViewModel(model: $0) }
            
            completion(historyViewModel)
        }
    }
   
}

struct EntryViewModel: Equatable {
    var value: String
    
    public static func ==(lhs: EntryViewModel, rhs: EntryViewModel) -> Bool {
        return lhs.value == rhs.value
    }
}

private extension EntryViewModel {
    init(model: Entry) {
        let value = NumberFormatter.localizedString(from: NSNumber(value: model.value), number: .currency)
        self.init(value: value)
    }
}
