// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IntervalCallPackage",
    platforms: [
        .iOS(.v26),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "IntervalCallPackage",
            targets: [
                MyModule.featureApp.name
            ]
        ),
    ],
    dependencies: [
        ThirdParty.Package.swiftComposableArchitecture.dependency,
    ],
    targets: [
        .target(
            name: MyModule.core.name,
            dependencies: [
                ThirdParty.Product.swiftComposableArchitecture.targetDependency,
            ],
            path: MyModule.core.folderPath
        ),
        .target(
            name: MyModule.featureAds.name,
            dependencies: [
            ],
            path: MyModule.featureAds.folderPath
        ),
        .target(
            name: MyModule.featureApp.name,
            dependencies: [
                MyModule.featureIntervalCall.dependency,
                ThirdParty.Product.swiftComposableArchitecture.targetDependency
            ],
            path: MyModule.featureApp.folderPath
        ),
        .target(
            name: MyModule.featureIntervalCall.name,
            dependencies: [
                MyModule.core.dependency,
                ThirdParty.Product.swiftComposableArchitecture.targetDependency
            ],
            path: MyModule.featureIntervalCall.folderPath
        )
    ]
)

/// 自作モジュール
enum MyModule {
    case core
    case featureApp
    case featureIntervalCall
    case featureAds
    
    var folderPath: String {
        return switch self {
        case .core:
            "Sources/Core"
        case .featureAds:
            "Sources/Feature/Ads"
        case .featureApp:
            "Sources/Feature/App"
        case .featureIntervalCall:
            "Sources/Feature/IntervalCall"
        }
    }
    
    var name: String {
        return "Internal" + folderPath
            .replacingOccurrences(of: "Sources", with: "")
            .replacingOccurrences(of: "/", with: "")
    }

    var dependency: Target.Dependency {
        return .byName(name: name, condition: nil)
    }
}

/** 外部ライブラリ */
struct ThirdParty {
    /** 外部ライブラリパッケージ */
    enum Package {
        case swiftComposableArchitecture

        var dependency: PackageDescription.Package.Dependency {
            return switch self {
            case .swiftComposableArchitecture:
                .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.23.1")
            }
        }
    }

    /** 外部ライブラリプロダクト */
    enum Product {
        case swiftComposableArchitecture

        var targetDependency: Target.Dependency {
            return switch self {
            case .swiftComposableArchitecture:
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            }
        }
    }
}
