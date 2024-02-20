import RealityKit

public enum Location: String, Codable
{
    case timesSquare
    case esb
    case back
}
// Ensure you register this component in your app’s delegate using:
// PointofInterestComponent.registerComponent()
public struct PointofInterestComponent: Component, Codable {
    // This is an example of adding a variable to the component.
    var location: Location = .esb
    public var name: String = "Learn More"
    
    public var description: String? = nil
    
    public init() {
    }
}
