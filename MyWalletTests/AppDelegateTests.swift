import XCTest
@testable import MyWallet

class AppDelegateTests: XCTestCase {
    
    var sut: AppDelegate!
    
    override func setUp() {
        sut = AppDelegate()
    }
    
    //MARK: Incoming Query: Assert result

    func testDidFinishLaunchingDoesReturnTrue() {
        let expected = true
        
        let actual = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        XCTAssertEqual(actual, expected)
    }
    
}
