import XCTest
@testable import MyWallet

class ViewModel3Tests: XCTestCase {
    
    var sut: ViewModel3!
    var testStorage: TestStorage!
    
    override func setUp() {
        testStorage = TestStorage()
        sut = ViewModel3(storage: testStorage)
    }
    
    //MARK: Incoming Query: Assert result
    
    func testLoadHistoryDoesReturn() {
        let expt = expectation(description: "completion")
        let value = 2.0
        let localizedValue = NumberFormatter.localizedString(from: NSNumber(value: 2.0), number: .currency)
        let expectedHistory = [EntryViewModel(value: localizedValue)]
        
        sut.loadHistory { (history) in
            XCTAssertEqual(history, expectedHistory)
            expt.fulfill()
        }
        
        testStorage.completion?([Entry(value: value)])
        
        waitForExpectations(timeout: 3) { (error) in
            XCTAssertNil(error)
        }
    }
}
