//
//  Models.swift
//  LearningAcademy
//
//  Created by Manish Parihar on 24.10.23.
//

import Foundation

struct User: Codable {
    let id: Int
    let gender: Gender?
    let dateOfBirth, job, city, zipcode: String
    let latitude: Double
    let profilePicture: String?
    let firstName, lastName, email, phone: String
    let street, state, country: String
    let longitude: Double
}

enum Gender: String, Codable {
    case female = "female"
    case male   = "male"
}
