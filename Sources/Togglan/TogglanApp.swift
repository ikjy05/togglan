import SwiftUI

@main
struct TogglanApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        MenuBarExtra {
            MenuContent(state: state)
        } label: {
            Image(systemName: state.isEnabled ? "cable.connector" : "cable.connector.slash")
        }
        .menuBarExtraStyle(.menu)
    }
}

struct MenuContent: View {
    @ObservedObject var state: AppState

    var body: some View {
        if let selectedService = state.selectedService {
            Text(selectedService)
            Text(state.isEnabled ? "연결됨" : "연결 끊김")

            Button(state.isEnabled ? "랜선 끊기" : "랜선 연결") {
                state.toggle()
            }
        } else {
            Text("이더넷 인터페이스를 찾을 수 없습니다")
        }

        if state.availableServices.count > 1 {
            Divider()
            Menu("인터페이스 선택") {
                ForEach(state.availableServices) { service in
                    Button {
                        state.selectService(service.name)
                    } label: {
                        if service.name == state.selectedService {
                            Text("✓ \(service.name)")
                        } else {
                            Text(service.name)
                        }
                    }
                }
            }
        }

        Divider()
        Button("새로고침") {
            state.refreshStatus()
        }
        Button("종료") {
            NSApplication.shared.terminate(nil)
        }
    }
}
