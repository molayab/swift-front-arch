import Foundation

public protocol NetworkService {
    associatedtype Provider: NetworkServiceProvider
    var manager: NetworkManager { get }
    
    func request<Model: Codable>(_ service: Provider) async throws -> Model
}

public extension NetworkService {
    func request<Model: Codable>(_ service: Provider) async throws -> Model {
        return try await self.manager.request(service)
    }
}
