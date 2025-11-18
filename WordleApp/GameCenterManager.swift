import Foundation
import GameKit
import SwiftUI
import Combine

@MainActor
class GameCenterManager: NSObject, ObservableObject {
    static let shared = GameCenterManager()

    @Published var isAuthenticated: Bool = false
    @Published var showLeaderboard: Bool = false
    @Published var leaderboardID: String?
    @Published var playerName: String = "Not logged in"
    @Published var avatar: UIImage?

    override init() {
        super.init()
    }

    // MARK: - Authenticate
    func authenticate() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in

            // If Apple needs a login UI, present it
            if let vc = viewController {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let root = scene.windows.first?.rootViewController {
                    root.present(vc, animated: true)
                }
                return
            }

            // Authentication complete
            if GKLocalPlayer.local.isAuthenticated {
                self.isAuthenticated = true
                self.playerName = GKLocalPlayer.local.displayName
                self.loadAvatar()

                GKAccessPoint.shared.isActive = true
                GKAccessPoint.shared.location = .topLeading

            } else {
                self.isAuthenticated = false
            }

            if let error = error {
                print("Game Center authentication error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Load avatar
    private func loadAvatar() {
        GKLocalPlayer.local.loadPhoto(for: .small) { image, error in
            if let image = image {
                DispatchQueue.main.async {
                    self.avatar = image
                }
            }
        }
    }

    // MARK: - Submit score
    func submitScore(_ score: Int, to leaderboardID: String) async {
        guard GKLocalPlayer.local.isAuthenticated else { return }

        do {
            try await GKLeaderboard.submitScore(
                score,
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: [leaderboardID]
            )
            print("Score submitted")
        } catch {
            print("Score submission failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Show Leaderboard
    func presentLeaderboard(_ id: String) {
        leaderboardID = id
        showLeaderboard = true
    }
}
