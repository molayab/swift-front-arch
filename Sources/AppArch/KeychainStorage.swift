import Foundation
import KeychainAccess

/**
    # KeychainStorage
    KeychainStorage is a property wrapper that allows you to store Codable objects in the keychain.
 
    ## Usage
    ```swift
    struct User: Codable {
        let name: String
        let age: Int
    }
    
    @KeychainStorage(key: "user") var user: User?
    print(user) // nil
    user = User(name: "Mateo", age: 23)
    print(user) // User(name: "Mateo", age: 23)
    ```
 */
@MainActor
@propertyWrapper
public struct KeychainStorage<T: Codable> {
    public let key: String
    public let keychain: Keychain
    
    public init(key: String, keychain: Keychain = Keychain()) {
        self.key = key
        self.keychain = keychain
    }
    
    public var wrappedValue: T? {
        get {
            guard let data = try? keychain.getData(key),
                    let value = try? JSONDecoder().decode(T.self, from: data) else {
                return nil
            }
            
            return value
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            try? keychain.set(data, key: key)
        }
    }
}
