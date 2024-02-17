import RealityKit

public enum Interests: String, Codable
{
    case first
    case second
}

// Ensure you register this component in your app’s delegate using:
// POIComponent.registerComponent()
public struct POIComponent: Component, Codable {
    // This is an example of adding a variable to the component.
    var location: Interests = .first

    public init() {
    }
}


