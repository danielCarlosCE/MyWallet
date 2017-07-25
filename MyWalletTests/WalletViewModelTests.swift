import XCTest
@testable import MyWallet

class WalletViewModelTests: XCTestCase {
    
    var sut: WalletViewModel!
    var testStorage: TestStorage!
    
    override func setUp() {
        testStorage = TestStorage()
        sut = WalletViewModel(storage: testStorage)
    }
    
    //MARK: Incoming command: Assert direct public effects
    func testAddExpenseDoesUpdateWallet() {
        sut.addExpense(20)
        
        XCTAssertEqual(sut.wallet.balance, balanceValue(for: testStorage.wallet.balance))
        XCTAssertEqual(sut.wallet.status, .negative)
    }
    
    func testAddCreditDoesUpdateWallet() {
        sut.addCredit(20)
        
        XCTAssertEqual(sut.wallet.balance, balanceValue(for: testStorage.wallet.balance))
        XCTAssertEqual(sut.wallet.status, .positive)
    }
    
    //MARK: Outgoing command: Expect to send
    
    func testAddExpenseWithPositiveValueDoesAddNegativeValue() {
        sut.addExpense(20)
        
        XCTAssertEqual(testStorage.addedValue, -20)
    }
    
    func testAddExpenseWithNegativeValueDoesAddNegativeValue() {
        sut.addExpense(-20)
        
        XCTAssertEqual(testStorage.addedValue, -20)
    }
    
    func testAddCreditWithPositiveValueDoesAddPositiveValue() {
        sut.addCredit(20)
        
        XCTAssertEqual(testStorage.addedValue, 20)
    }
    
    func testAddCreditWithNegativeValueDoesAddPositiveValue() {
        sut.addCredit(-20)
        
        XCTAssertEqual(testStorage.addedValue, 20)
    }
    
    func testAddExpenseDoesCallDelegate() {
        let delegate = TestDelegate()
        sut.delegate = delegate
        
        sut.addExpense(45)
        
        XCTAssertEqual(delegate.newValue, sut.wallet)
    }
    
    func testAddCreditDoesCallDelegate() {
        let delegate = TestDelegate()
        sut.delegate = delegate
        
        sut.addCredit(45)
        
        XCTAssertEqual(delegate.newValue, sut.wallet)
    }
    
    //MARK: Mocks 
    
    class TestDelegate: ViewModelDelegate {
        var newValue: Wallet?
        func walletDiChange(newValue wallet: Wallet) {
            newValue = wallet
        }
    }
    
    //MARK: Helpers
    
    private func balanceValue(for balance: Double) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: balance), number: .currency)
    }
    
}
