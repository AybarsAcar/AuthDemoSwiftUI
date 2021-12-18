//
//  WebService.swift
//  AuthDemo
//
//  Created by Aybars Acar on 19/12/2021.
//

import Foundation


enum AuthenticationError: Error {
  case invalidCredentials
  case custom(errorMessage: String)
}

enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
}


struct LoginRequestBody: Codable {
  let username: String
  let password: String
}

struct LoginResponse: Codable {
  let token: String?
  let message: String?
  let success: Bool?
}


struct Constants {
  static let baseUrl = "https://strong-spangled-apartment.glitch.me/"
}


class WebService {
  
  
  func getAllAccounts(token: String, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
    
    // unwrap the url
    guard let url = URL(string: "\(Constants.baseUrl)accounts") else {
      completion(.failure(.invalidURL))
      return
    }
    
    // build the request
    var request = URLRequest(url: url)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    // perform the request
    URLSession.shared.dataTask(with: request) { data, response, error in
      
      guard let data = data, error == nil else {
        completion(.failure(.noData))
        return
      }
      
      guard let accounts = try? JSONDecoder().decode([Account].self, from: data) else {
        completion(.failure(.decodingError))
        return
      }
      
      // success
      completion(.success(accounts))

    }.resume()
  }
  
  
  func login(username: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
    
    // unwrap the url
    guard let url = URL(string: "\(Constants.baseUrl)login") else {
      completion(.failure(.custom(errorMessage: "URL is incorrect")))
      return
    }
    
    // create the login request body
    let body = LoginRequestBody(username: username, password: password)
    
    // build the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONEncoder().encode(body)
    
    // perform the request
    URLSession.shared.dataTask(with: request) { data, response, error in
      
      // extract the data
      guard let data = data, error == nil else {
        completion(.failure(.custom(errorMessage: "No data available")))
        return
      }

      // decode the response the our LoginResponse object
      guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
        completion(.failure(.invalidCredentials))
        return
      }
      
      // get the token out
      guard let token = loginResponse.token else {
        completion(.failure(.invalidCredentials))
        return
      }
      
      // success
      completion(.success(token))
      
    }.resume()
  }
}
