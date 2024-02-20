//
//  ViewModel.swift
//  City
//
//  Created by Arun Kulkarni on 16/02/24.
//

import Foundation
import RealityKit
import RealityKitContent
import Observation
import MapKit

@Observable
final class ViewModel {
        
    var selectedPlaceInfo: PlaceInfo?
    var placeInfoList: [PlaceInfo] = [
        PlaceInfo(name: "Times Square", locationCoordinate: CLLocationCoordinate2DMake(40.758896, -73.985130), panoId: "Xx_P23DsZzDM84ubzYq4_w"),
        PlaceInfo(name: "Empire State Building", locationCoordinate: CLLocationCoordinate2DMake(40.748817, -73.985428), panoId: "V6Cn6nfTJCMZNRWF-quDRQ")
    ]
    
    var rootEntity = Entity()
    var isChatView = true
    private let width = 4096
    private let height = 2048
    private var contentEntity = Entity()
    private var modelEntity: ModelEntity? = nil
    private var snapshotImage: UIImage = .init()
    
    var titleText: String = ""
    var isTitleFinished: Bool = false
    var finalTitle: String = "Wanderlust GENIE: Your Itinerary Teaser"

    /// Fetches image and adds to the contentEntity for street view
    func setSnapshot() async throws {
        guard let placeInfo = selectedPlaceInfo else { return }

        Task { @MainActor in
            snapshotImage = try await fetchImage(panoId: placeInfo.panoId)

            guard let cgImage = snapshotImage.cgImage else { return }
            guard let texture = try? await TextureResource.generate(from: cgImage, options: TextureResource.CreateOptions.init(semantic: nil)) else { return }

            var material = modelEntity?.model?.materials[0] as! UnlitMaterial
            material.color = .init(texture: MaterialParameters.Texture(texture))
            modelEntity?.model?.materials[0] = material
        }
    }
    
    func setupBackgroundEntityOnLaunch() -> Entity {
        let modelEntity = ModelEntity()

        let material = UnlitMaterial(color: .blue)
        modelEntity.components.set(ModelComponent(
            mesh: .generateSphere(radius: 1E3),
            materials: [material]
        ))
        modelEntity.scale *= .init(x: -1, y: 1, z: 1)
        modelEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)

        contentEntity.addChild(modelEntity)
        self.modelEntity = modelEntity

        return contentEntity
    }
    /// Adds the immersive view of street view to current volume
    func setupContentEntity() -> Entity {
        if let modelEntity = self.modelEntity {
            modelEntity.removeFromParent()
        }

        let modelEntity = ModelEntity()

        let material = UnlitMaterial(color: .gray)
        modelEntity.components.set(ModelComponent(
            mesh: .generateSphere(radius: 1E3),
            materials: [material]
        ))
        modelEntity.scale *= .init(x: -1, y: 1, z: 1)
        modelEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)

        contentEntity.addChild(modelEntity)
        self.modelEntity = modelEntity

        return contentEntity
    }
    
    /// Scale the model
    func updateScale() {
        let newScale: Float = lerp(1.5, 1.5, 1.5)
        rootEntity.setScale(SIMD3<Float>(repeating: newScale), relativeTo: nil)
        rootEntity.isEnabled = false
    }
    
    func resetScale() {
        let newScale: Float = lerp(0.4, 0.4, 0.4)
        rootEntity.setScale(SIMD3<Float>(repeating: newScale), relativeTo: nil)
        rootEntity.isEnabled = true
    }
    
    /// API.
    private func fetchImage(panoId: String) async throws -> UIImage {

        var images: [UIImage] = []

        var baseUrl = URL(string: "https://streetviewpixels-pa.googleapis.com/v1/tile")!
        let paramsCommon: [URLQueryItem] = [
            URLQueryItem(name: "cb_client", value: "maps_sv.tactile"),
            URLQueryItem(name: "panoid", value: panoId),
            URLQueryItem(name: "zoom", value: "\(3)")
        ]
        baseUrl.append(queryItems: paramsCommon)

        for y in 0..<4 {
            for x in 0..<8 {
                var _url = baseUrl
                let params: [URLQueryItem] = [
                    URLQueryItem(name: "x", value: "\(x)"),
                    URLQueryItem(name: "y", value: "\(y)")
                ]
                _url.append(queryItems: params)

                let request = URLRequest(url: _url)
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.networkError
                }

                if let image = UIImage(data: data) {
                    images.append(image)
                }
            }
        }

        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }

        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))

        let size = 512

        for (index, image) in images.enumerated() {
            let yIndex = index / 8
            let xIndex = index - yIndex * 8
            let cgImage = image.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: size, height: size))
            UIImage(cgImage: cgImage!).draw(at: CGPoint(x: CGFloat(xIndex * size), y: CGFloat(yIndex * size)))
        }

        if let uiImage = UIGraphicsGetImageFromCurrentImageContext() {
            return uiImage
        } else {
            return UIImage()
        }
    }
}

enum APIError: Error {
    case networkError
    case unknown

    var title: String {
        switch self {
        case .networkError:
            return "network error"
        case .unknown:
            return "unknown error"
        }
    }
}

struct PlaceInfo: Identifiable, Hashable {
    static func == (lhs: PlaceInfo, rhs: PlaceInfo) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id = UUID()
    let name: String
    let locationCoordinate: CLLocationCoordinate2D
    let panoId: String
}

struct PointOfInterestRuntimeComponent: Component {
    let attachmentTag: ObjectIdentifier
}
