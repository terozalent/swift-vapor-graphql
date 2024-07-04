import Graphiti
import Vapor

// Arguments
struct PaginationArguments: Codable {
  let limit: Int
  let offset: Int
}

// Resolvers
final class Resolver {
  func getAllShows(
    request: Request,
    arguments: PaginationArguments
  ) throws -> EventLoopFuture<[Show]> {
    Show.query(on: request.db)
      .limit(arguments.limit)
      .offset(arguments.offset)
      .all()
  }

  struct CreateShowArguments: Codable {
    let title: String
    let releaseYear: Int
  }

  func createShow(
    request: Request,
    arguments: CreateShowArguments
  ) throws -> EventLoopFuture<Show> {
    let show = Show(
      title: arguments.title,
      releaseYear: arguments.releaseYear
    )
    return show.create(on: request.db).map { show }
  }

  struct UpdateShowArguments: Codable {
    let id: UUID
    let title: String
    let releaseYear: Int
  }

  func updateShow(
    request: Request,
    arguments: UpdateShowArguments
  ) throws -> EventLoopFuture<Bool> {
    Show.find(arguments.id, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { (show: Show) -> EventLoopFuture<()> in
        show.title = arguments.title
        show.releaseYear = arguments.releaseYear
        return show.update(on: request.db)
      }
      .transform(to: true)
  }

  struct DeleteShowArguments: Codable {
    let id: UUID
  }

  func deleteShow(
    request: Request,
    arguments: DeleteShowArguments
  ) -> EventLoopFuture<Bool> {
    Show.find(arguments.id, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { $0.delete(on: request.db) }
      .transform(to: true)
  }

  func getAllReviews(
  request: Request,
  arguments: PaginationArguments
  ) throws -> EventLoopFuture<[Review]> {
    Review.query(on: request.db)
      .limit(arguments.limit)
      .offset(arguments.offset)
      .all()
  }

  struct CreateReviewArguments: Codable {
    let showID: UUID
    let title: String
    let text: String
  }

  func createReview(
    request: Request,
    arguments: CreateReviewArguments
  ) throws -> EventLoopFuture<Review> {
    let review = Review(
      showID: arguments.showID,
      title: arguments.title,
      text: arguments.text
    )
    return review.create(on: request.db).map { review }
  }

  struct UpdateReviewArguments: Codable {
    let id: UUID
    let title: String
    let text: String
  }

  func updateReview(
    request: Request,
    arguments: UpdateReviewArguments
  ) throws -> EventLoopFuture<Bool> {
    Review.find(arguments.id, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { (review: Review) -> EventLoopFuture<()> in
        review.title = arguments.title
        review.text = arguments.text
        return review.update(on: request.db)
      }
      .transform(to: true)
  }

  struct DeleteReviewArguments: Codable {
    let id: UUID
  }

  func deleteReview(
    request: Request,
    arguments: DeleteReviewArguments
  ) -> EventLoopFuture<Bool> {
    Review.find(arguments.id, on: request.db)
      .unwrap(or: Abort(.notFound))
      .flatMap { $0.delete(on: request.db) }
      .transform(to: true)
  }
}