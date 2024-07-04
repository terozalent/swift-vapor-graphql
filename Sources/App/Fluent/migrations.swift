import Fluent

// Shows migration
struct Shows: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("shows")
            .id()
            .field("title", .string, .required)
            .field("releaseYear", .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("reviews").delete()
    }
}

// Reviews migration
struct Reviews: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("reviews")
      .id()
      .field("title", .string, .required)
      .field("text", .string, .required)
      .field("show_id", .uuid, .required, .references("shows", "id"))
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    return database.schema("reviews").delete()
  }
}