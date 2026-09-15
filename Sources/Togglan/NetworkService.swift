import Foundation

enum NetworkService {
    struct Service: Identifiable, Hashable {
        var id: String { name }
        let name: String
        let isEnabled: Bool
    }

    private static let networksetupPath = "/usr/sbin/networksetup"

    private static let excludedNamePatterns = [
        "wi-fi", "bluetooth", "thunderbolt bridge", "iphone", "ipad"
    ]

    private static func run(_ arguments: [String]) -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: networksetupPath)
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return ""
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }

    static func allServiceNames() -> [String] {
        let output = run(["-listallnetworkservices"])
        return output
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty && !$0.hasPrefix("An asterisk") }
            .map { $0.hasPrefix("*") ? String($0.dropFirst()) : $0 }
    }

    static func isEnabled(_ serviceName: String) -> Bool {
        run(["-getnetworkserviceenabled", serviceName])
            .trimmingCharacters(in: .whitespacesAndNewlines) == "Enabled"
    }

    static func setEnabled(_ serviceName: String, enabled: Bool) {
        _ = run(["-setnetworkserviceenabled", serviceName, enabled ? "on" : "off"])
    }

    /// Ethernet-like services, excluding Wi-Fi/Bluetooth/Thunderbolt Bridge/phone tethering.
    static func candidateEthernetServices() -> [Service] {
        allServiceNames()
            .filter { name in
                let lower = name.lowercased()
                return !excludedNamePatterns.contains { lower.contains($0) }
            }
            .map { Service(name: $0, isEnabled: isEnabled($0)) }
    }
}
