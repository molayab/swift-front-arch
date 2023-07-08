import Foundation

/**
 # Injector
 Injector is the base protocol for all dependencies. It is used to define the dependencies for a view model or service as a common type. You can create custom dependencies containers by conforming to this protocol. Each dependency container acts as a layer that can be used to inject dependencies into some given context.

 The Framework provides two default dependency containers:
    - `ServiceDependencies`: Used to define dependencies for services.
    - `ViewModelDependencies`: Used to define dependencies for view models.

 ## Create a custom dependency container
 ```swift
 protocol MyCustomGroupOfDependencies: Injector { }
 protocol MyCustomProviderProtocol: Injectable where Dependencies: MyCustomGroupOfDependencies { }

 // Adding dependencies to the container

 extension MyCustomGroupOfDependencies {
     static func inject() -> MyCustomDependency {
         return MyCustomDependency()
     }
 }

 // Using the container
 final class MyCustomProvider: MyCustomProviderProtocol {
    struct Dependencies: MyCustomGroupOfDependencies {
        var myCustomDependency: MyCustomDependency = inject()
    }
    
    let dependencies: Dependencies
    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }
 }
 ```
 */
public protocol Injector { }
public protocol ServiceDependencies: Injector { }
public protocol ViewModelDependencies: Injector { }

public protocol Injectable {
    associatedtype Dependencies: Injector
    var dependencies: Dependencies { get }
}

/**
 # Service
 Service is a protocol that represent a Service artifact in your project, it only requires to conform to `Injectable` protocol using ServiceDependencies container for injection.
 
 ## Usage
 ```swift
 protocol MyService: Service {
    struct Dependencies: ServiceDependencies {
        var myDependency: MyDependency = inject()
    }
 }
 ```
 */
public protocol Service: Injectable where Dependencies: ServiceDependencies { }
/**
 # ViewModel
 ViewModel is a protocol that represent a ViewModel artifact in your project, it only requires to conform to `Injectable` protocol using ViewModelDependencies container for injection.

 ## Usage
 ```swift
 protocol MyViewModel: ViewModel {
     struct Dependencies: ViewModelDependencies {
         var myDependency: MyDependency = inject()
     }
 }
 ```
 */
public protocol ViewModel: Injectable where Dependencies: ViewModelDependencies { }
