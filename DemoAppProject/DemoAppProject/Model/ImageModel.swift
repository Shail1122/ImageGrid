//
//  ImageModel.swift
//  DemoAppProject
//
//  Created by Shailendra Tripathi on 24/10/24.
//

import Foundation

// MARK: - MyImageDataModel
struct MyImageDataModel: Identifiable, Codable {
    let id, title: String
    let language: Language
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
    let description, seoSlugWithID: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, language, thumbnail, mediaType, coverageURL, publishedAt, publishedBy, backupDetails, description
        case seoSlugWithID = "seoSlugWithId"
    }
    
    // MARK: - BackupDetails
    struct BackupDetails: Codable {
        let pdfLink: String
        let screenshotURL: String
    }
    
    enum Language: String, Codable {
        case english = "english"
        case hindi = "hindi"
    }
    
    // MARK: - Thumbnail
    struct Thumbnail: Codable {
        let id: String
        let version: Int
        let domain: String
        let basePath: String
        let key: Key
        let qualities: [Int]
        let aspectRatio: Double
    }
    
    enum Key: String, Codable {
        case imageJpg = "image.jpg"
    }
}
