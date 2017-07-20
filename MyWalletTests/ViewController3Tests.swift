import XCTest
@testable import MyWallet

class ViewController3Tests: XCTestCase {
    
    var sut: ViewController3!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func setUp() {
        sut = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as? ViewController3
    }
    //MARK: Incoming Query: Assert result

    func testNumberOfRowsDoesReturnHistoryCount() {
        let testViewModel = TestViewModel3()
        sut.viewModel = testViewModel
        _ = sut.view
        testViewModel.completion?([EntryViewModel(value: "$20.00")])
        
        eventually("will update tableview") {
            
            let numberOfRows = self.sut.tableView(self.sut.tableView, numberOfRowsInSection: 0)
            let fullfilled = numberOfRows == 1
            
            XCTAssert(fullfilled)
            
            return fullfilled
        }
    }
    
    func testCellForRowDoesReturnSetCell() {
        let testViewModel = TestViewModel3()
        sut.viewModel = testViewModel
        _ = sut.view
        testViewModel.completion?([EntryViewModel(value: "$20.00")])
        
        eventually("will update tableview") {
            
            let cell = self.sut.tableView(self.sut.tableView, cellForRowAt: IndexPath(row:0, section: 0))
            let fullfilled = cell.textLabel?.text == "$20.00"
            
            XCTAssert(fullfilled)
            
            return fullfilled
        }

    }
    
    //MARK: Outgoing command: Expect to send
    
    //⚠️ We're couped with UIKit implementation, not justing "expecting to send" ⚠️
    func testCloseDoesDismiss() {
        let vc = UIViewController()
        setRootControllerSomeWindow(viewController: vc)
        vc.present(sut, animated: false, completion: nil)
        XCTAssert(vc.presentedViewController == self.sut)
        
        self.sut.close(vc)
        
        self.eventually("dismiss sut") {
            let fullfilled = vc.presentedViewController == nil
            XCTAssert(fullfilled)
            
            return fullfilled
        }
    }
    
    class TestViewModel3: ViewModel3Type {
        var completion: (([EntryViewModel]) -> Void)?
        func loadHistory(completion: @escaping ([EntryViewModel]) -> Void) {
            self.completion = completion
        }
    }
}
