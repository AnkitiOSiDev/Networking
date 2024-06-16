//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Ankit on 25/05/24.
//

import XCTest
@testable import Networking

class NetworkingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNetworkManager_Success() {
        
        let url = URL(string: "https://github.com/endpint")!
        let data =  MockUser(userId: 1).jsonData()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        
        let networkManager = NetworkManager(session: mockSession)
        let request = MockUrlRequest.test
        let parser = ResponseParser<MockUser>()
        let expectation = XCTestExpectation(description: "test Network manager")
        let mockApiService = MockApiService(networkManager: networkManager)
        
        mockApiService.getData(endpoint: request, parser: parser) { result in
            switch result {
            case .success(let model):
                XCTAssertNotNil(model)
                XCTAssertEqual(model.userId, 1)
                break
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testNetworkManager_Failure() {
        
        let url = URL(string: "https://github.com/endpint")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (MockError(), nil, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        
        let networkManager = NetworkManager(session: mockSession)
        let request = MockUrlRequest.test
        let parser = ResponseParser<MockUser>()
        let expectation = XCTestExpectation(description: "test Network manager")
        let mockApiService = MockApiService(networkManager: networkManager)
        
        mockApiService.getData(endpoint: request, parser: parser) { result in
            switch result {
            case .success(let model):
                XCTAssertNil(model)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, .apiError(error: MockError()))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testNetworkManager_Failure_Invalidurl() {
        
        let url = URL(string: "https://github.com/endpint")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data =  MockUser(userId: 1).jsonData()
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        
        let networkManager = NetworkManager(session: mockSession)
        let request = MockUrlInvalidRequest.test
        let parser = ResponseParser<MockUser>()
        let expectation = XCTestExpectation(description: "test Network manager")
        let mockApiService = MockApiService(networkManager: networkManager)
        
        mockApiService.getData(endpoint: request, parser: parser) { result in
            switch result {
            case .success(let model):
                XCTAssertNil(model)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, .invalidUrl)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testNetworkManager_Failure_InvalidResponse() {
        
        let url = URL(string: "https://github.com/endpint")!
        let data =  MockUser(userId: 1).jsonData()
        URLProtocolMock.mockURLs = [url: (nil, data, nil)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        
        let networkManager = NetworkManager(session: mockSession)
        let request = MockUrlRequest.test
        let parser = ResponseParser<MockUser>()
        let expectation = XCTestExpectation(description: "test Network manager")
        let mockApiService = MockApiService(networkManager: networkManager)
        
        mockApiService.getData(endpoint: request, parser: parser) { result in
            switch result {
            case .success(let model):
                XCTAssertNil(model)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, .invalidResponse)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testNetworkManager_Failure_InvalidHttpResponseCode() {
        
        let url = URL(string: "https://github.com/endpint")!
        let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        let data =  MockUser(userId: 1).jsonData()
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        
        let networkManager = NetworkManager(session: mockSession)
        let request = MockUrlRequest.test
        let parser = ResponseParser<MockUser>()
        let expectation = XCTestExpectation(description: "test Network manager")
        let mockApiService = MockApiService(networkManager: networkManager)
        
        mockApiService.getData(endpoint: request, parser: parser) { result in
            switch result {
            case .success(let model):
                XCTAssertNil(model)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, .httpResponseError(statusCode: 400))
                XCTAssertNotEqual(error, .invalidUrl)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testNetworkManager_Failure_Parsing() {
        
        let url = URL(string: "https://github.com/endpint")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data =  Data()
        URLProtocolMock.mockURLs = [url: (nil, data, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        
        let networkManager = NetworkManager(session: mockSession)
        let request = MockUrlRequest.test
        let parser = ResponseParser<MockUser>()
        let expectation = XCTestExpectation(description: "test Network manager")
        let mockApiService = MockApiService(networkManager: networkManager)
        
        mockApiService.getData(endpoint: request, parser: parser) { result in
            switch result {
            case .success(let model):
                XCTAssertNil(model)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, .parsingError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

    }
    
//    func testNetworkManager_Failure_NoData() {
//
//        let url = URL(string: "https://github.com/endpint")!
//        URLProtocolMock.mockURLs = [url: (nil, nil, response)]
//
//        let sessionConfiguration = URLSessionConfiguration.ephemeral
//        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
//        let mockSession = URLSession(configuration: sessionConfiguration)
//
//        let networkManager = NetworkManager(session: mockSession)
//        let request = MockUrlRequest.test
//        let parser = ResponseParser<MockUser>()
//        let expectation = XCTestExpectation(description: "test Network manager")
//        let mockApiService = MockApiService(networkManager: networkManager)
//
//        mockApiService.getData(endpoint: request, parser: parser) { result in
//            switch result {
//            case .success(let model):
//                XCTAssertNil(model)
//                break
//            case .failure(let error):
//                XCTAssertNotNil(error)
//                XCTAssertEqual(error, .noData)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//
//    }
    
    func test_apierror() {
        let url = URL(string: "https://github.com/endpint")!
        URLProtocolMock.mockURLs = [url: (nil, nil, nil)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let networkManager = NetworkManager(session: mockSession)
        let request = MockUrlRequest.test
        let parser = ResponseParser<MockUser>()
        let expectation = XCTestExpectation(description: "test Network manager")
        let mockApiService = MockApiService(networkManager: networkManager)
        
        mockApiService.getData(endpoint: request, parser: parser) { result in
                   switch result {
                   case .success(let model):
                       XCTAssertNil(model)
                       break
                   case .failure(let error):
                       XCTAssertNotNil(error)
                       XCTAssertEqual(error, .noData)
                   }
                   expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}

enum MockUrlRequest: ApiRequestable {
    var baseURL: URL? {
        return URL(string: "https://github.com")
    }
    
    var path: String {
       return "/endpint"
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var headers: [String : String]? { return nil }
    
    var body: RequestBody? { return nil }
    
    case test
}

enum MockUrlInvalidRequest: ApiRequestable {
    var baseURL: URL? {
        return nil
    }
    
    var path: String {
       return "/endpint"
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var headers: [String : String]? { return nil }
    
    var body: RequestBody? { return nil }
    
    case test
}

struct MockUser: ResponseBody, RequestBody {
    let userId: Int
}

class URLProtocolMock: URLProtocol {
    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = URLProtocolMock.mockURLs[url] {
                if let responseStrong = response {
                    client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }
                
                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }
                
                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }

        // Send the signal that we are done returning our mock response
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Required to be implemented. Do nothing here.
    }
}

class MockApiService: ApiServiceProtocol {
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    var networkManager: NetworkManagerProtocol
}

struct MockError: Error {}

class MockUrlSession: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        MockSessionDataTask.init {
            completionHandler(self.data, self.response, self.error)
        }
    }
}

class MockSessionDataTask: URLSessionDataTask {
    let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    
    override func resume() {
        self.closure()
    }
}


protocol URLSessionProtocol {
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

class MockableUrlSession: URLSessionProtocol {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    func dataTask(with: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.init(configuration: .default).dataTask(with: with) { _,_,_  in
            completionHandler(self.data, self.urlResponse, self.error)
        }
    }
}

class MockUrlDataTask: URLSessionDataTask { }
