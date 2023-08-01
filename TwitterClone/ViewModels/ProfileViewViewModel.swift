//
//  ProfileViewViewModel.swift
//  TwitterClone
//
//  Created by Burit Boonkorn on 2/8/2566 BE.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel: ObservableObject {
    private var subscriptions: Set<AnyCancellable> = []

    @Published var user: TwitterUser?
    @Published var error: String?
        
    func retreiveUser() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.collectionUsers(retreive: id)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
}
