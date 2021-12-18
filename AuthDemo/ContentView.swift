//
//  ContentView.swift
//  AuthDemo
//
//  Created by Aybars Acar on 19/12/2021.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject private var loginViewModel: LoginViewModel = LoginViewModel()
  @ObservedObject private var accountListViewModel: AccountListViewModel = AccountListViewModel()
  
  var body: some View {
    
    VStack {
      Form {
        HStack {
          Spacer()
          Image(systemName: loginViewModel.isAuthenticated ? "lock.open" : "lock.fill")
        }
        
        TextField("Username", text: $loginViewModel.username)
        TextField("Password", text: $loginViewModel.password)
        
        HStack {
          Spacer()
          Button("Login") {
            loginViewModel.login()
          }
          Button("Sign out") {
            loginViewModel.signout()
            accountListViewModel.accounts.removeAll()
          }
          Spacer()
        }
        .buttonStyle(.plain)
      }
      
      VStack {
        Spacer()
        
        if loginViewModel.isAuthenticated && accountListViewModel.accounts.count > 0 {
          
          List(accountListViewModel.accounts, id: \.id) { account in
            HStack {
              Text("\(account.name)")
              Spacer()
              Text(String(format: "$%.2f", account.balance))
            }
          }
          .listStyle(.plain)
          
        } else {
          Text("Login to see the accounts")
        }
        
        Spacer()
        
        Button("Get Accounts") {
          accountListViewModel.getAllAccounts()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
