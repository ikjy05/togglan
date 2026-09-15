import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var selectedService: String?
    @Published private(set) var isEnabled: Bool = true
    @Published private(set) var availableServices: [NetworkService.Service] = []

    private static let selectedServiceKey = "selectedServiceName"

    init() {
        refreshAvailableServices()

        if let saved = UserDefaults.standard.string(forKey: Self.selectedServiceKey),
           availableServices.contains(where: { $0.name == saved }) {
            selectedService = saved
        } else {
            selectedService = availableServices.first?.name
        }

        refreshStatus()
    }

    func refreshAvailableServices() {
        availableServices = NetworkService.candidateEthernetServices()
    }

    func refreshStatus() {
        refreshAvailableServices()
        guard let selectedService else { return }
        isEnabled = NetworkService.isEnabled(selectedService)
    }

    func selectService(_ name: String) {
        selectedService = name
        UserDefaults.standard.set(name, forKey: Self.selectedServiceKey)
        refreshStatus()
    }

    func toggle() {
        guard let selectedService else { return }
        NetworkService.setEnabled(selectedService, enabled: !isEnabled)
        refreshStatus()
    }
}
