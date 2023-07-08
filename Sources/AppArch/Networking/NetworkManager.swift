//
//  File.swift
//  
//
//  Created by Mateo Olaya on 7/07/23.
//

import Foundation

public actor NetworkManager {
    @KeychainStorage(key: "token") private var token: String?
    private var session: URLSession!
    private lazy var decoder: JSONDecoder = {
        let formatter = JSONDecoder()
        formatter.dateDecodingStrategy = .iso8601
        return formatter
    }()
    private lazy var encoder: JSONEncoder = {
        let formatter = JSONEncoder()
        formatter.dateEncodingStrategy = .iso8601
        return formatter
    }()
    
    
    public init(config: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: config)
    }
    
    public var isVerbose: Bool = false
    
    /**
     This method is used to configure the authentication token. It is the value of the header
     field `Authorization`,when you are using basic, bearer or any other authentication method
     you MUST provide the token in the correct format and the required prefix.
     
     Example:
     ```Basic <token>```
        - Parameter token: The token to be used in the header field `Authorization` encoded in base64
     ```Bearer <token>```
        - Parameter token: The token to be used in the header field `Authorization`
     */
    @MainActor
    public func authenticate(token: String) {
        self.token = token
    }
    
    @MainActor
    public func getAuthotizationToken() -> String? {
        return token
    }
    
    public func setDefaultHeader(_ value: String, for key: String) {
        session.configuration.httpAdditionalHeaders?[key] = value
    }
    
    public func requestSampleData<Model>(_ data: Data) async throws -> Model where Model: Codable {
        return try decoder.decode(Model.self, from: data)
    }

    /**
     This method is used to request data from the server. It is an asynchronous method and it will try to
     decode the response data into the model provided or throws an error if it fails.
     
     Manager will send token configured as Authorization header field. It will also send all default
     headers configured.
     */
    public func request<Model>(_ req: NetworkServiceProvider) async throws -> Model where Model: Codable {
        var request = URLRequest(url: URL(string: req.path)!)
        request.httpMethod = req.method.rawValue
        
        if let token = await token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        req.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = req.buildPayload(usingFormatter: encoder)
        request.setValue(req.encoding.rawValue, forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        if isVerbose {
            print(" --> Request: \(req.method.rawValue) \(req.path)")
            if let data = request.httpBody {
                print("  -> Payload:")
                print(String(data: data, encoding: .utf8) ?? "")
                print("  <----------")
            }
            print(" --> Headers:")
            print(request.allHTTPHeaderFields ?? [:])
            print("  <----------")
            print("  -> Response:")
            String(data: data, encoding: .utf8).map { print($0) }
            print("  -> Response Context:")
            print(response.debugDescription)
            print("=================================================")
        }
        
        return try decoder.decode(Model.self, from: data)
    }
}
