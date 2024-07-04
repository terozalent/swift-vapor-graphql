import Vapor
import FluentSQLiteDriver
import GraphQLKit

public func configure(_ app: Application) async throws {
    // Database configuration
    app.databases.use(.sqlite(.memory), as: .sqlite)

    // Migration configuration
    app.migrations.add(Shows())
    app.migrations.add(Reviews())
    try await app.autoMigrate()

    // GraphQL configuration
    app.register(graphQLSchema: schema, withResolver: Resolver(), at: "")
}
