//
//  OfflineImageManipulationTests.swift
//  OfflineImageManipulationTests
//
//  Created by Calugar George on 03/09/2026.
//

import XCTest

@testable import OfflineImageManipulation

final class OfflineImageManipulationTests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    @MainActor
    func test_loadData_usesMockItems() async {
        let mock = WallpapersRepositoryMock()
        let vm = ImageListViewModel(repository: mock)
        await vm.loadData()
        XCTAssertEqual(vm.images.count, 1)
        XCTAssertEqual(mock.fetchCount, 1)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    

}
