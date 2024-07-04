import Graphiti
import Vapor

let schema = try! Schema<Resolver, Request> {
  Scalar(UUID.self)
  
  // Define Review type
  Type(Review.self) {
    Field("id", at: \.id)
    Field("title", at: \.title)
    Field("text", at: \.text)
  }

  // Define Show type
  Type(Show.self) {
    Field("id", at: \.id)
    Field("title", at: \.title)
    Field("releaseYear", at: \.releaseYear)
    Field("reviews", at: Show.getReviews) {
      Argument("limit", at: \.limit)
      Argument("offset", at: \.offset)
    }
  }

  Query {
    // Show queries
    Field("shows", at: Resolver.getAllShows) {
      Argument("limit", at: \.limit)
      Argument("offset", at: \.offset)
    }

    // Review queries
    Field("reviews", at: Resolver.getAllReviews) {
      Argument("limit", at: \.limit)
      Argument("offset", at: \.offset)
    }
  }

  Mutation {
    // Show mutations
    Field("createShow", at: Resolver.createShow) {
      Argument("title", at: \.title)
      Argument("releaseYear", at: \.releaseYear)
    }

    Field("updateShow", at: Resolver.updateShow) {
      Argument("id", at: \.id)
      Argument("title", at: \.title)
      Argument("releaseYear", at: \.releaseYear)
    }

    Field("deleteShow", at: Resolver.deleteShow) {
      Argument("id", at: \.id)
    }

    // Review mutations
    Field("createReview", at: Resolver.createReview) {
      Argument("showID", at: \.showID)
      Argument("title", at: \.title)
      Argument("text", at: \.text)
    }

    Field("updateReview", at: Resolver.updateReview) {
      Argument("id", at: \.id)
      Argument("title", at: \.title)
      Argument("text", at: \.text)
    }

    Field("deleteReview", at: Resolver.deleteReview) {
      Argument("id", at: \.id)
    }
  }
}