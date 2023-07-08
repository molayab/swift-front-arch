# SimpleArch

SimpleArch is a *swifty*, lightweight, and easy to use way to define your macOS, iOS, tvOS, and watchOS app's architecture using a SOLID architecture patterns. It also provides a simple way to interact with URLSession inspired by [Moya](https://github.com/Moya/Moya). It is inspired by [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) and SOLID design patterns. It is written in Swift 5.1 and is compatible with macOS 10.13+, iOS 11.0+, tvOS 11.0+, and watchOS 4.0+.

## Installation
The package is available through [Swift Package Manager](https://swift.org/package-manager/).


## Usage
### KeychainStorage
KeychainStorage is a property wrapper that allows you to store Codable objects in the keychain.
 
#### Example
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
    
### Navigation
SimpleArch provides a simple way to navigate between screens. It defines a `NavigationRouter` protocol type that represents a router that can handle the navigation of your app. You MUST use only reference typed artifacts to define your routers, and conform to this protocol to use the navigator. Create a `class` or `actor` that conforms to this protocol and use it as an __environment object__ in your app. You can use the navigator to navigate to any view in your app, using the link's associated values to send data to the view. The router is able to ask for the associted link's view or generate navigation links to the associated views.

#### Example
 Defining your router using a class, you can use any navigation way to show the view, and you can use the link's associated values to send data to the view.
    
 ```swift
 final class Navigator: NavigatorRouter, ObservableObject {
     // Add any other custom navigation logic here
    @Published var isLoginRequired = false
    
    ...
 
    func do(foo: Any) { ... }
 }
 
 // You can use the router to ask for the view of a link
    navigator.view(forLink: ExampleFlowLinks.index)

 // You can use the router to create a link to a view using string title
    navigator.link(title: "Index", to: ExampleFlowLinks.index)
 
 // Even better, you can use the navigator to navigate to a view using a view.
    navigator.navigate(label: Text("Hello"), to: ExampleFlowLinks.index)
 
 // Define your navigator as an environment object and interact with it in your views
 
 struct ExampleView: View {
     @EnvironmentObject var navigator: Navigator
     
     var body: some View {
         NavigationView {
             VStack {
                 NavigationLink("Index", destination: AnyView(ExampleFlowLinks.index.view))
                 navigator.navigate(title: "Show 1", to: ExampleFlowLinks.show(1))
             }
             
         }
     }
 }

 struct ExampleView_Previews: PreviewProvider {
     static var previews: some View {
         ExampleView()
             .environmentObject(Navigator())
     }
 }
 ```
### Architecture
#### Injector
```swift
protocol Injector { }
protocol Injectable {
    associatedtype Dependencies: Injector
    var dependencies: Dependencies { get }
}
```

Injector is the base protocol for all dependencies. It is used to define the dependencies for a view model or service as a common type. You can create custom dependencies containers by conforming to this protocol. Each dependency container acts as a layer that can be used to inject dependencies into some given context.

The Framework provides two default dependency containers:
    - `ServiceDependencies`: Used to define dependencies for services.
    - `ViewModelDependencies`: Used to define dependencies for view models.
 
##### Create a custom dependency container
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
fincal class MyCustomProvider: MyCustomProviderProtocol {
    struct Dependencies: MyCustomGroupOfDependencies {
        var myCustomDependency: MyCustomDependency = inject()
    }
    
    let dependencies: Dependencies
    init(dependencies: Dependencies = Dependencies()) {
        self.dependencies = dependencies
    }
}

```
#### Service
Service is a protocol that represent a Service artifact in your project, it only requires to conform to `Injectable` protocol using ServiceDependencies container for injection.
     
##### Usage
```swift
protocol MyService: Service {
    struct Dependencies: ServiceDependencies {
        var myDependency: MyDependency = inject()
    }
}
```

#### ViewModel
ViewModel is a protocol that represent a ViewModel artifact in your project, it only requires to conform to `Injectable` protocol using ViewModelDependencies container for injection.

##### Usage
```swift
protocol MyViewModel: ViewModel {
    struct Dependencies: ViewModelDependencies {
        var myDependency: MyDependency = inject()
    }
}
```
