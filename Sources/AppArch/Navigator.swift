import Foundation
import SwiftUI

/**
 # NavigatorLink
 A protocol type that represents a link to a SwiftUI View. You should use enums to represent the different
 links in your app, conforming to this protocol you can use the enum cases as links to the views. You can send
 data to the view using the enum's associated values. For more fancy ways to define your routes, you can use
 structs, classes, or actors to define your links, but for simplicity, I recommend using enums.
 
 ## Example
 Defining your links using enums, each case represents a link to a view, and the associated values are the
 data you can send to that view.
 
 ```swift
 enum ExampleFlowLinks: NavigatorLink {
     case index
     case show(Int)
     
     @MainActor @ViewBuilder
     var view: any View {
         switch self {
         case .index:
             Text("Index View !!!")
         case .show(let id):
             Text("Showing \(id)'s View !!!")
         }
     }
 }
 
 // Then use any navigation way to show the view
 
 NavigationLink("Index", destination: AnyView(ExampleFlowLinks.index.view))
 
 or
 
 .fullScreenCover(isShowing: $isShowing) {
    AnyView(ExampleFlowLinks.index.view)
 }
 
 ```
 */
public protocol NavigatorLink {
    @MainActor @ViewBuilder var view: any View { get }
}

/**
 # NavigatorRouter
 A protocol type that represents a router that can handle the navigation of your app. You should use
 referenced-type artifacts to define your routers, and conform to this protocol to use the navigator. Create
 a class or actor that conforms to this protocol and use it as an environment object in your app. You can use
 the navigator to navigate to any view in your app, using the link's associated values to send data to the view.
 
 ## Example
 Defining your router using a class, you can use any navigation way to show the view, and you can use the
 link's associated values to send data to the view.
    
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
 */
public protocol NavigatorRouter: AnyObject {
    @MainActor @ViewBuilder
    func view(forLink link: any NavigatorLink) -> AnyView
    
    @MainActor @ViewBuilder
    func link(title: String, to link: any NavigatorLink) -> NavigationLink<Text, AnyView>
    
    @MainActor @ViewBuilder
    func link(label: any View, to link: any NavigatorLink) -> NavigationLink<AnyView, AnyView>
}

public extension NavigatorRouter {
    @MainActor @ViewBuilder
    func view(forLink link: any NavigatorLink) -> AnyView {
        AnyView(link.view)
    }
    
    @MainActor @ViewBuilder
    func link(title: String, to link: any NavigatorLink) -> NavigationLink<Text, AnyView> {
        NavigationLink(title, destination: AnyView(link.view))
    }
    
    @MainActor @ViewBuilder
    func link(label: any View, to link: any NavigatorLink) -> NavigationLink<AnyView, AnyView> {
        NavigationLink(destination: AnyView(link.view)) {
            AnyView(label)
        }
    }
}
