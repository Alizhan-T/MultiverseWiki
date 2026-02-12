import Foundation
import os

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.MultiverseWiki"

    static let network = Logger(subsystem: subsystem, category: "Network")
    static let data = Logger(subsystem: subsystem, category: "CoreData")
    static let ui = Logger(subsystem: subsystem, category: "UI")
}
