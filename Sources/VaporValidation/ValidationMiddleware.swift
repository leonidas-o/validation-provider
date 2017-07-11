import HTTP
import Validation
import JSON
import Vapor

/// Catches validation errors and prints
/// out a more readable JSON response.
@available(*, deprecated, message: "Please import ValidationProvider instead of VaporValidation.")
public final class ValidationMiddleware: Middleware {
    public init() {}

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch let error as ValidationError {
            var json = JSON([:])
            try json.set("error", true)
            try json.set("message", error.reason)

            let response = Response(status: .badRequest)
            response.json = json
            return response
        }
    }
}

extension ValidationMiddleware: ConfigInitializable {
    public convenience init(config: Config) throws {
        self.init()
    }
}
