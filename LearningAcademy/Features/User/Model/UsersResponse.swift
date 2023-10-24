//
//  UsersResponse.swift
//  LearningAcademy
//
//  Created by Manish Parihar on 24.10.23.
//

import Foundation

// MARK: - USER RESPONSE
struct UsersResponse : Codable {
    let success: Bool
    let message: String?
    let totalUsers, offset, limit: Int
    let data: [User]
}
