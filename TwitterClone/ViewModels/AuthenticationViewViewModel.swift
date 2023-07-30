//
//  RegisterViewViewModel.swift
//  TwitterClone
//
//  Created by Burit Boonkorn on 30/7/2566 BE.
//

import Foundation
import Firebase
import Combine

//ObservableObject -> can hold Publishers which is going to notify the views which we're going to subscribe for those publishers whenever a new change occurs to them
final class AuthenticationViewViewModel: ObservableObject {
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationFormValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateAuthenticationForm() {
        guard let email = email,
              let password = password else {
            isAuthenticationFormValid = false
            return
        }
        
        isAuthenticationFormValid = isValidEmail(email) && password.count >= 8
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser() {
        guard let email = email,
              let password = password else {
            return
        }
        
        AuthManager.shared.registerUser(with: email, password: password)
            .handleEvents( receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error.localizedDescription
                }
                
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscriptions)
    }
    
    func createRecord(for user: User) {
        DatabaseManager.shared.collectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("Adding user record to database: \(state)")
            }
            .store(in: &subscriptions)

    }

    func loginUser() {
        guard let email = email,
              let password = password else {
            return
        }
        
        AuthManager.shared.loginUser(with: email, password: password)
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
