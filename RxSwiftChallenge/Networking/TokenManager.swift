//
//  TokenManager.swift
//  RxSwiftChallenge
//
//  Created by TSAI TSUNG-HAN on 2021/7/17.
//

import Foundation
import KKBOXOpenAPISwift

class TokenManager {

  let api = KKBOXOpenAPI(clientID: "8c83abf3bd461ab4efceeb975390199f",
                         secret: "5997c9952aca5fdcbaf9cc2a3c9068bf")

  func getToken(completionHandler: @escaping (String) -> Void) {
    do {
      _ = try api.fetchAccessTokenByClientCredential { result in
        switch result {
        case .error(let error):
          print(error)
        case .success(let token):
          completionHandler(token.accessToken)
//          print(token.accessToken)
        }
      }
    } catch {
      print(error)
    }
  }
}
