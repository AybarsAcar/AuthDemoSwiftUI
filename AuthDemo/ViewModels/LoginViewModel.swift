//
//  LoginViewModel.swift
//  AuthDemo
//
//  Created by Aybars Acar on 19/12/2021.
//

import Foundation


class LoginViewModel: ObservableObject {
  
  var username: String = ""
  var password: String = ""
  
  @Published var isAuthenticated: Bool = false
  
  
  private var _api: WebService = WebService()
  
  
  func login() {
    
    // get user defaults - token will be stored in UserDefaults
    let defaults = UserDefaults.standard
    
    _api.login(username: username, password: password) { result in
      
      switch result {
        
      case .success(let token):
        defaults.setValue(token, forKey: "token")
        DispatchQueue.main.async {
          self.isAuthenticated = true
        }
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  
  func signout() {
    let defaults = UserDefaults.standard
    
    defaults.removeObject(forKey: "token")
    
    DispatchQueue.main.async {
      self.isAuthenticated = false
    }
  }
}
