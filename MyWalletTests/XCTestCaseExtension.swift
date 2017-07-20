import XCTest

extension XCTestCase {
    //MARK: Helpers
    func eventually(_ expect: String, wait: TimeInterval = 2.5, completion: @escaping () -> Bool) {
        let expec = expectation(description: expect)
        
        DispatchQueue(label: expect).async {
            sleep(UInt32(wait))
            
            let fullfilled = completion()
            if fullfilled {
                expec.fulfill()
            }
        }
        waitForExpectations(timeout: 3) { _ in }
    }
    
    func setRootControllerSomeWindow(viewController vc: UIViewController) {
        let window = UIWindow()
        window.rootViewController = vc
        //necessary for presents to work
        window.makeKeyAndVisible()
    }
}
