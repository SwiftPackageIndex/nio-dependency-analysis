import Foundation

let fm = FileManager.default

// loop over directories
// open Package.resolved to see if NIO is a dependency
//   - if there's no Package.resolved, run swift package dump-package with 5.4
// print NIP dependees
// check if they support 5.2+ in the index


func packageResolve(packageDirectory: URL) throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
    process.arguments = ["package", "resolve"]
    process.currentDirectoryURL = packageDirectory
    try process.run()
    process.waitUntilExit()
}


func dependsOnNIO(packageDirectory: URL) throws -> Bool {
    struct Resolved: Codable {
        var object: Object

        struct Object: Codable {
            var pins: [Pin]

            struct Pin: Codable {
                var package: String
                var repositoryURL: String
            }
        }

        var dependsOnNIO: Bool {
            for pin in object.pins {
                if pin.package.lowercased() == "swift-nio" { return true }
                if pin.repositoryURL.lowercased().contains("apple/swift-nio.git") { return true }
            }
            return false
        }
    }

    let failedMarker = packageDirectory.appendingPathComponent("resolve-failed").path
    guard !fm.fileExists(atPath: failedMarker) else { return false }

    let resolved = packageDirectory.appendingPathComponent("Package.resolved")
    guard let data = try? Data(contentsOf: resolved) else {
        try packageResolve(packageDirectory: packageDirectory)
        guard fm.fileExists(atPath: resolved.path) else {
            print("ERROR: Package.resolved could not be created (\(packageDirectory.path))")
            fm.createFile(atPath: failedMarker, contents: nil)
            return false
        }
        return try dependsOnNIO(packageDirectory: packageDirectory)
    }
    guard let res = try? JSONDecoder().decode(Resolved.self, from: data) else {
        print("ERROR: decoding error (\(packageDirectory.path))")
        return false
    }
    return res.dependsOnNIO 
}


func main() throws {
    let checkoutDir = URL(fileURLWithPath: "checkouts", isDirectory: true)
    var count = 0
    for fname in try fm.contentsOfDirectory(atPath: checkoutDir.path) {
        if count % 100 == 0 { print(count) }
        count += 1
        let packageDir = checkoutDir.appendingPathComponent(fname)
        if try dependsOnNIO(packageDirectory: packageDir) {
            print("depends on NIO: \(fname)")
        }
    }
}

try main()
