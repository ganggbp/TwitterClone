//
//  ProfileDataFormViewViewModel.swift
//  TwitterClone
//
//  Created by Burit Boonkorn on 30/7/2566 BE.
//

import Foundation
import Combine

final class ProfileDataFormViewViewModel: ObservableObject {
    @Published var displayName: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
}
