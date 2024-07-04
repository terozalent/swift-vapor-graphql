@testable import App
import XCTVapor
import GraphQL

final class AppTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        app = try await Application.make(.testing)
        try await configure(app)
    }
    
    override func tearDown() async throws { 
        try await app.asyncShutdown()
        app = nil
    }
    
    func testQueries() throws {
        try app.test(.POST, "/", beforeRequest: { req in
            try req.content.encode([
                "query": "query { shows(limit: 10, offset: 0) { id title } }"
                ])
        }, afterResponse: { res in 
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, """
            {"data":{"shows":[]}}
            """)
        })
    }
    
    func testMutatuions() throws {
        try app.test(.POST, "/", beforeRequest: { req in
            try req.content.encode([
                "query": """
                mutation {
                    createShow(
                        title: "The Chilling Adventures of RESTful Heroes"
                        releaseYear: 2020
                    ) {
                        title
                    }
                }
                """
                ])
        }, afterResponse: { res in 
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, """
            {"data":{"createShow":{"title":"The Chilling Adventures of RESTful Heroes"}}}
            """)
        })
    }
}
