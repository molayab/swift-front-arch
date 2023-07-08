import Foundation

public enum NetworkServiceMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
}

public enum NetworkServiceContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}
