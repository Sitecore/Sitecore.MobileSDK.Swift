
import XCTest
@testable import SitecoreSSC_SDK

class ParsersTests: XCTestCase
{
    override func setUp()
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSingleParserCorrectData()
    {
        let singleItemParser = SingleItemResponseParser()
        let json = StringTestData.correctSingleItemJson
        let data = json.data(using: .utf8)!
        let result: [ISitecoreItem] = singleItemParser.parseData(data: data, sessionConfig: nil, source: nil)
        
        XCTAssertTrue(result.count == 1)
        let item: ISitecoreItem = result[0]
        XCTAssertTrue(item.displayName == "sitecore", "item name expected: 'sitecore', but actually: \(item.displayName)")
        XCTAssertTrue(item.hasChildren)
        XCTAssertTrue(item.id == UUID(uuidString: "11111111-1111-1111-1111-111111111111"))
        XCTAssertTrue(item.path == "/sitecore")
        XCTAssertTrue(item.templateId == "c6576836-910c-4a3d-ba03-c277dbd3b827")
        XCTAssertTrue(item.fieldsCount == 14)
        XCTAssertFalse(item.isMediaImage)
    }
    
    func testSingleParserBadData()
    {
        let singleItemParser = SingleItemResponseParser()
        let json = StringTestData.badJson
        let data = json.data(using: .utf8)!
        let result: [ISitecoreItem] = singleItemParser.parseData(data: data, sessionConfig: nil, source: nil)
        
        XCTAssertTrue(result.count == 0)
    }

    func testMultipleParserCorrectData()
    {
        let multipleItemParser = ItemsListResponseJsonParser()
        let json = StringTestData.correctMultipleItemsJson
        let data = json.data(using: .utf8)!
        let result: [ISitecoreItem] = multipleItemParser.parseData(data: data, sessionConfig: nil, source: nil)
        
        XCTAssertTrue(result.count == 6)
        let item: ISitecoreItem = result[0]
        XCTAssertTrue(item.displayName == "Content", "item name expected: 'content', but actually: \(item.displayName)")
    }
    
    func testMultipleParserBadData()
    {
        let multipleItemParser = ItemsListResponseJsonParser()
        let json = StringTestData.badJson
        let data = json.data(using: .utf8)!
        let result: [ISitecoreItem] = multipleItemParser.parseData(data: data, sessionConfig: nil, source: nil)
        
        XCTAssertTrue(result.count == 0)
    }
    
    func testSearchParserCorrectData()
    {
        let searchItemParser = SearchResponseJsonParser()
        let json = StringTestData.correctSearchItemsJson
        let data = json.data(using: .utf8)!
        let result: [ISitecoreItem] = searchItemParser.parseData(data: data, sessionConfig: nil, source: nil)
        
        XCTAssertTrue(result.count == 2)
        let item: ISitecoreItem = result[0]
        XCTAssertTrue(item.displayName == "Nassau", "item name expected: 'Nassau', but actually: \(item.displayName)")
    }
    
    func testSearchParserBadData()
    {
        let searchItemParser = SearchResponseJsonParser()
        let json = StringTestData.badJson
        let data = json.data(using: .utf8)!
        let result: [ISitecoreItem] = searchItemParser.parseData(data: data, sessionConfig: nil, source: nil)
        
        XCTAssertTrue(result.count == 0)
    }
}
