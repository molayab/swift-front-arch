import Foundation

public protocol NetworkServiceProvider {
    var path: String { get }
    var method: NetworkServiceMethod { get }
    var headers: [String: String] { get }
    var encoding: NetworkServiceContentType { get }
    
    func buildPayload(usingFormatter formatter: JSONEncoder) -> Data?
}

public extension NetworkServiceProvider {
    var headers: [String: String] {
        return [:]
    }
    
    var encoding: NetworkServiceContentType {
        return .json
    }
    
    func buildPayload(usingFormatter formatter: JSONEncoder) -> Data? {
        return nil
    }
}
