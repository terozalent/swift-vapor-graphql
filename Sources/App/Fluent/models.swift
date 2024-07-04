import Fluent
import Vapor

// Show model
final class Show: Model, Content {
    static let schema = "shows"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "releaseYear")
    var releaseYear: Int

    @Children(for: \.$show)
    var reviews: [Review]

    init(){}

    init(id: UUID? = nil, title: String, releaseYear: Int) {
        self.id = id
        self.title = title
        self.releaseYear = releaseYear
    }
}

extension Show {
  func getReviews(
    request: Request,
    arguments: PaginationArguments
  ) throws -> EventLoopFuture<[Review]> {
    $reviews.query(on: request.db)
      .limit(arguments.limit)
      .offset(arguments.offset)
      .all()
  }
}

// Review model
final class Review: Model, Content {
  static let schema = "reviews"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "title")
  var title: String

  @Field(key: "text")
  var text: String

  @Parent(key: "show_id")
  var show: Show

  init() { }

  init(id: UUID? = nil, showID: UUID, title: String, text: String) {
    self.id = id
    self.$show.id = showID
    self.title = title
    self.text = text
  }
}