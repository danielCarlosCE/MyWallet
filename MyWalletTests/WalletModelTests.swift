import XCTest
@testable import MyWallet

class WalletModelTests: XCTestCase {
    
    //MARK: Incoming command: Assert direct public effects
    
    func testInitDoesSetProperties() {
        let expected = 2.5
        
        let actual = WalletModel(balance: expected).balance
        
        XCTAssertEqual(actual, expected)
    }
    
    
}
