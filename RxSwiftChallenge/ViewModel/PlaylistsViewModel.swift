//
//  PlaylistsViewModel.swift
//  RxSwiftChallenge
//
//  Created by TSAI TSUNG-HAN on 2021/7/18.
//

import Foundation
import RxSwift

class PlaylistsViewModel {

  let tracks: PublishSubject<[Track]> = PublishSubject()

  var tracksArray: [Track] = []
  
  var favoriteTracks: [String] = []

  let isLoading = BehaviorSubject(value: false)

  let noMoreData = BehaviorSubject(value: false)

  let tokenManager = TokenManager()

  func getTracks() {
    isLoading.onNext(true)
    tokenManager.getToken { token in
      DataManager.shared.getTracks(with: token) { tracks in
        guard !tracks.data.isEmpty else {
          self.noMoreData.onNext(true)
          self.isLoading.onNext(false)
          return
        }
        self.tracksArray += tracks.data
        DataManager.shared.offset = self.tracksArray.count
        self.tracks.onNext(self.tracksArray)
        self.isLoading.onNext(false)
      }
    }
  }

}
