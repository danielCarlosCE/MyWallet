import XCTest
@testable import MyWallet

class WalletTests: XCTestCase {
    
    //MARK: Incoming command: Assert direct public effects
    
    func testInitDoesSetProperties() {
        let expected = 2.5
        
        let actual = Wallet(balance: expected).balance
        
        XCTAssertEqual(actual, expected)
    }
    
    
}
