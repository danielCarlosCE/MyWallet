import XCTest
@testable import MyWallet

class WalletViewModelTests: XCTestCase {
    
    //MARK: Incoming command: Assert direct public effects
    
    func testInitDoesSetProperties() {
        let expectedBalance = "$5.00"
        let expectedStatus = WalletViewModel.Status.positive
        
        let sut = WalletViewModel(balance: expectedBalance, status: expectedStatus)
        
        XCTAssertEqual(sut.balance, expectedBalance)
        XCTAssertEqual(sut.status, expectedStatus)
    }
    
    //MARK: Incoming Query: Assert result
    
    func testEqualsDoesConsiderBalanceStatus() {
        let sut = WalletViewModel(balance: "-$55", status: .negative)
        let sameSut = WalletViewModel(balance: "-$55", status: .negative)
        let differentSut1 = WalletViewModel(balance: "$10", status: .negative)
        let differentSut2 = WalletViewModel(balance: "-$55", status: .positive)
        
        XCTAssert(sut == sameSut)
        XCTAssert(sut != differentSut1)
        XCTAssert(sut != differentSut2)
    }
    
}
