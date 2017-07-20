import XCTest
@testable import MyWallet

class ViewControllerTests: XCTestCase {
    
    var sut: ViewController!
    var testViewModel: TestViewModel!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func setUp() {
        sut = storyboard.instantiateInitialViewController() as? ViewController
        
        testViewModel = TestViewModel()
        sut.viewModel = testViewModel
        
        //trigger loadView (can't call directly) and viewDidLoad
        _ = sut.view
    }
    
    //MARK: Incoming command: Assert direct public effects
    
    func testLoadViewDoesSetOutlets() {
        XCTAssertNotNil(sut.balanceLabel)
    }
    
    func testViewDidLoadDoesSetViewModelDelegate() {
        XCTAssertNotNil(testViewModel.delegate)
    }
    
    func testViewDidLoadDoesUpdateOutletsValues() {
        XCTAssertEqual(sut.balanceLabel.text, sut.viewModel.wallet.balance)
    }
    
    func testPrepareForSegueWithAddExpenseDoesSetDestination() {
        let destination = storyboard.instantiateViewController(withIdentifier: "InputVC") as! ViewController2
        let segue = UIStoryboardSegue(identifier: "addExpense", source: sut, destination: destination)
        
        sut.prepare(for: segue, sender: nil)
        
        XCTAssertNotNil(destination.completion)
        XCTAssertEqual(destination.type, .expense)
    }
    
    func testCompletionDoesCallViewModelAddExpense() {
        let destination = storyboard.instantiateViewController(withIdentifier: "InputVC") as! ViewController2
        let segue = UIStoryboardSegue(identifier: "addExpense", source: sut, destination: destination)
        let expense = 2.0
        
        sut.prepare(for: segue, sender: nil)
        destination.completion?(expense)
        
        XCTAssertEqual(testViewModel.wallet.balance, "-\(expense)")
    }
    
    func testPrepareForSegueWithAddCreditDoesSetDestination() {
        let destination = storyboard.instantiateViewController(withIdentifier: "InputVC") as! ViewController2
        let segue = UIStoryboardSegue(identifier: "addCredit", source: sut, destination: destination)
        
        sut.prepare(for: segue, sender: nil)
        
        XCTAssertNotNil(destination.completion)
        XCTAssertEqual(destination.type, .credit)
    }
    
    func testPrepareForSegueWithWrongDestinationDoesNotCrash() {
        let reachedHereSinceDidntCrash = true
        let segue = UIStoryboardSegue(identifier: "addCredit", source: sut, destination: UIViewController())
        
        
        sut.prepare(for: segue, sender: nil)
        
        
        XCTAssert(reachedHereSinceDidntCrash)
    }
    
    func testWalletDidChangeWithPositiveBalanceDoesUpdateOutlets() {
        let expectedBalance = "$35.00"
        sut.walletDiChange(newValue: WalletViewModel(balance: expectedBalance, status: .positive))
        
        XCTAssertEqual(sut.balanceLabel.text, expectedBalance)
        XCTAssertEqual(sut.balanceLabel.textColor, .green)
    }
    
    func testWalletDidChangeWithNegativeBalanceDoesUpdateOutlets() {
        let expectedBalance = "-$35.00"
        sut.walletDiChange(newValue: WalletViewModel(balance: expectedBalance, status: .negative))
        
        XCTAssertEqual(sut.balanceLabel.text, expectedBalance)
        XCTAssertEqual(sut.balanceLabel.textColor, .red)
    }
    
    //MARK: Outgoing command: Expect to send

    func testCompletionDoesCallViewModelAddCredit() {
        let destination = storyboard.instantiateViewController(withIdentifier: "InputVC") as! ViewController2
        let segue = UIStoryboardSegue(identifier: "addCredit", source: sut, destination: destination)
        let credit = 2.0
        
        sut.prepare(for: segue, sender: nil)
        destination.completion?(credit)
        
        XCTAssertEqual(testViewModel.wallet.balance, "+\(credit)")
    }
    
    //⚠️ We're couped with UIKit implementation, not justing "expecting to send" ⚠️
    func testAddExpenseDoesPresentVC2() {
        setRootControllerSomeWindow(viewController: sut)
        
        sut.addExpense()
        
        eventually("presents vc2") {
            let fulfilled = self.sut.presentedViewController is ViewController2
            XCTAssert(fulfilled)
            return fulfilled
        }
    }
    func testAddCreditDoesPresentVC2() {
        setRootControllerSomeWindow(viewController: sut)
        
        sut.addCredit()
        
        eventually("presents vc2") {
            let fulfilled = self.sut.presentedViewController is ViewController2
            XCTAssert(fulfilled)
            return fulfilled
        }
    }
    
    
    //MARK: Mocks
    
    class TestViewModel: ViewModelType {
        weak var delegate: ViewModelDelegate?
        private(set) var wallet: WalletViewModel = WalletViewModel(balance: "$0.00", status: .positive)
        
        func addExpense(_ value: Double) {wallet.balance = "-\(value)"}
        func addCredit(_ value: Double) {wallet.balance = "+\(value)"}
    }
    
}
