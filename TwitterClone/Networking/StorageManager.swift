//
//  StorageManager.swift
//  TwitterClone
//
//  Created by Burit Boonkorn on 1/8/2566 BE.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FirestorageError: Error {
    case invalidImageID
}

final class StorageManager {
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else {
            return Fail(error: FirestorageError.invalidImageID)
                .eraseToAnyPublisher()
        }
        
        return storage
            .reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
    
    func uploadProfilePhoto(
        with randomID: String,
        image: Data,
        metaData: StorageMetadata
    ) -> AnyPublisher<StorageMetadata, Error> {
        storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
    
}
