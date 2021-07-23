//
//  Playlists.swift
//  RxSwiftChallenge
//
//  Created by TSAI TSUNG-HAN on 2021/5/6.
//

import Foundation

// MARK: - Playlists
struct Playlists: Codable {
  let tracks: Tracks
  let id: String
  let title: String
}

// MARK: - Tracks
struct Tracks: Codable {
  let data: [Track]
  let paging: Paging
}

//MARK: - Paging
struct Paging: Codable {
  let offset: Int
  let limit: Int
  let next: String?
}

// MARK: - Track
struct Track: Codable {
  let id: String
  let name: String
  let album: Album
}

// MARK: - Album
struct Album: Codable {
  let images: [Image]
}

// MARK: - Image
struct Image: Codable {
  let height: Int
  let width: Int
  let url: String
}

enum AvailableTerritory: String, Codable {
  case hk = "HK"
  case jp = "JP"
  case my = "MY"
  case sg = "SG"
  case tw = "TW"
}

