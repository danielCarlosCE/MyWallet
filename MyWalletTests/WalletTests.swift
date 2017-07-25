import XCTest
@testable import MyWallet

class WalletTests: XCTestCase {
    
    //MARK: Incoming command: Assert direct public effects
    
    func testInitDoesSetProperties() {
        let expectedBalance = "$5.00"
        let expectedStatus = Wallet.Status.positive
        
        let sut = Wallet(balance: expectedBalance, status: expectedStatus)
        
        XCTAssertEqual(sut.balance, expectedBalance)
        XCTAssertEqual(sut.status, expectedStatus)
    }
    
    //MARK: Incoming Query: Assert result
    
    func testEqualsDoesConsiderBalanceStatus() {
        let sut           = Wallet(balance: "-$55", status: .negative)
        let sameSut       = Wallet(balance: "-$55", status: .negative)
        let differentSut1 = Wallet(balance:  "$10", status: .negative)
        let differentSut2 = Wallet(balance: "-$55", status: .positive)
        
        XCTAssert(sut == sameSut)
        XCTAssert(sut != differentSut1)
        XCTAssert(sut != differentSut2)
    }
    
}
