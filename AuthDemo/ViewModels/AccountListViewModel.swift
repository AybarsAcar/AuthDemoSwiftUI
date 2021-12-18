//
//  AccountListViewModel.swift
//  AuthDemo
//
//  Created by Aybars Acar on 19/12/2021.
//

import Foundation


class AccountListViewModel: ObservableObject {
  
  @Published var accounts: [AccountViewModel] = []
  
  private var _api: WebService = WebService()
  
  func getAllAccounts() {
    
    // get the token from the UserDefaults
    let defaults = UserDefaults.standard
    guard let token = defaults.string(forKey: "token") else { return }
    
    _api.getAllAccounts(token: token) { result in
      
      switch result {
        
      case .success(let accounts):
        // populate the accounts variable
        DispatchQueue.main.async {
          self.accounts = accounts.map(AccountViewModel.init)
        }
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}


struct AccountViewModel {
  
  let account: Account
  
  let id = UUID()
  
  var name: String {
    return account.name
  }
  
  var balance: Double {
    return account.balance
  }
}
