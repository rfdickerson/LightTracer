import XCTest

@testable import PathTracer

let redMaterial = Material(emission: Color(0.0 , 0, 0.0),
                           diffuseColor: Color(1.0, 0.0, 0.0),
                           ks: 0.0, kd: 0.7, n: 0)

class GraphicsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenSpaceToWorld() {
        
        // let coords = screenCoordinates(width: 10, height: 10)
        
        // XCTAssertEqual(coords.count, 100)
        
    }
    
    func testTriangleIntersection() {
        
        let triangle = Triangle(
            a: Vector3D(-1, -1, 0),
            b: Vector3D( 1, -1, 0),
            c: Vector3D( 0,  1, 0),
            material: redMaterial,
            objectToWorld: Transform()
        )
        
        let ray = Ray(origin: Vector3D(0, 0, -5),
                      direction: Vector3D(0, 0, 1))
        
        let intersection = triangle.intersect(ray: ray)
        
        XCTAssertNotNil(intersection)
        
        print(intersection ?? "No intersection")
        
        let ray2 = Ray(origin: Vector3D(0, 0, -5),
                       direction: Vector3D(0, 0, -1))
        
        let intersection2 = triangle.intersect(ray: ray2)
        
        XCTAssertNil(intersection2)
    }
    
    func testSphereIntersection() {
        let v = Vector3D(0, 0, 0)
        
        let direction = Vector3D(0, 0, -1)
        let direction2 = Vector3D(1, 0, 0)
        let direction3 = Vector3D(0, 1, 0)
        
        // let sphereCenter = Vector3D(0, 0, -5)
        
        let objectToWorld = Transform.translate(delta: Vector3D(0,0,-5))
        
        let sphere = Sphere(objectToWorld: objectToWorld, radius: 1, material: redMaterial)
        
        let intersection = sphere.intersect(ray: Ray(origin: v, direction: direction))
        
        XCTAssertNotNil(intersection)
        
        let intersection2 = sphere.intersect(ray: Ray(origin: v, direction: direction2))
        
        XCTAssertNil(intersection2)
        
        let intersection3 = sphere.intersect(ray: Ray(origin: v, direction: direction3))
        
        XCTAssertNil(intersection3)
        
    }
    
    func testTranslation() {
        
        let v = Vector3D(4, 5, 6)
        
        let t = Transform.translate(delta: Vector3D(2, 3, 4))
        
        let tv = t * v
        
        let correct = Vector3D(6, 8, 10)
        
        XCTAssertEqual(tv, correct)
        
    }
    
    func testScale() {
        
        let v = Vector3D(4, 5, 6)
        
        let t = Transform.scale(withScale: 2)
        
        let tv = t * v
        
        let correct = Vector3D(8, 10, 12)
        
        XCTAssertEqual(tv, correct)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
