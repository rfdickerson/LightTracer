import Foundation
import Dispatch

import SimplePNG

import PathTracer

print("Swift Monte-Carlo Path Tracing renderer")

try Scene.sharedInstance.load(withJSON: "scene.json")

let pathTracer = PathTracer()

pathTracer.render()



