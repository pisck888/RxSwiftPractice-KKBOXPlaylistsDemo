//
//  DataManager.swift
//  RxSwiftChallenge
//
//  Created by TSAI TSUNG-HAN on 2021/5/6.
//

import Foundation
import Alamofire


class DataManager {

  static let shared = DataManager()

  var offset = 0

  func getTracks(with token: String, completionHandler: @escaping (Tracks) -> Void) {

    let url = "https://api.kkbox.com/v1.1/new-hits-playlists/DZrC8m29ciOFY2JAm3/tracks"

    let headers: HTTPHeaders = [
      "Host": "api.kkbox.com",
      "Authorization": "Bearer \(token)"
    ]

    let parameters = [
      "territory": "TW",
      "offset": String(offset),
      "limit": "20"
    ]

    AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseDecodable(of: Tracks.self) { response in
      switch response.result {
      case .success(let tracks):
        completionHandler(tracks)
      case .failure(let error):
        print(error)
      }
    }

  }


}
