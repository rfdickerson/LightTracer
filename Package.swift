import PackageDescription

let package = Package(
    name: "SwiftTracer",
    targets: [
                 Target(
                    name: "SwiftTracer",
                    dependencies: [.Target(name: "PathTracer")]),
                 Target(
                    name: "PathTracer")
                 ]
)
