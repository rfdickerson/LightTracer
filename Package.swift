import PackageDescription

let package = Package(
    name: "SwiftTracer",
    targets: [
                 Target(
                    name: "SwiftTracer",
                    dependencies: [.Target(name: "MathUtils"), .Target(name: "PathTracer")]),
                 Target(
                    name: "MathUtils"
                    ),
                 Target(
                    name: "PathTracer",
                    dependencies: [.Target(name: "MathUtils")])
                 ]
)
