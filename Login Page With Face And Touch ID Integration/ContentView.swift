//
//  ContentView.swift
//  Login Page With Face And Touch ID Integration
//
//  Created by Admin on 9/22/20.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    
    @AppStorage("status") var logged = false
    
    var body: some View {
        NavigationView {
            
            if logged {
                Text("User Logged In...")
                    .navigationTitle("Home")
                    .navigationBarHidden(false)
                    .preferredColorScheme(.light)
            } else {
                Home()
                    //.preferredColorScheme(.dark)
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var email = ""
    @State var password = ""
    // When first user logged in via email store this for future biometric login...
    @AppStorage("stored_User") var user = "erlantemirbolat@gmail.com"
    @AppStorage("status") var logged = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("logo2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                // Dynamic Frame...
                .padding(.horizontal, 35)
                .padding(.vertical)
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Please sign in to continue")
                        .foregroundColor(Color.white.opacity(0.5))
                }
                
                Spacer()
            }
            .padding()
            .padding(.leading, 15)
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.white)
                    .font(.title2)
                    .frame(width: 35)
                
                TextField("EMAIL", text: $email)
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color.white.opacity(email == "" ? 0 : 0.12))
            .cornerRadius(15)
            .padding(.horizontal)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.white)
                    .font(.title2)
                    .frame(width: 35)
                
                SecureField("PASSWORD", text: $password)
                    .autocapitalization(.none)
            }
            .padding()
            .background(Color.white.opacity(password == "" ? 0 : 0.12))
            .cornerRadius(15)
            .padding(.horizontal)
            .padding(.top, 40)
            
            HStack(spacing: 15) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("LOGIN")
                        .foregroundColor(.black)
                        .fontWeight(.heavy)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .background(Color("green"))
                        .clipShape(Capsule())
                })
                .opacity(email != "" && password != "" ? 1 : 0.5)
                .disabled(email != "" && password != "" ? false : true)
                
                if getBioMetricStatus() {
                    Button(action: { authenticateUser() }, label: {
                        // Getting biometrictype...
                        Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .foregroundColor(.black)
                            .font(.title)
                            .padding()
                            .background(Color("green"))
                            .clipShape(Circle())
                    })
                }
            }
            .padding(.top)
            
            Button(action: {}, label: {
                Text("Forget password?")
                    .foregroundColor(Color("green"))
            })
            .padding(.top, 8)
            
            Spacer()
            
            HStack(spacing: 5) {
                Text("Don't have an account?")
                    .foregroundColor(Color.white.opacity(0.6))
                
                Button(action: {}, label: {
                    Text("SignUp")
                        .foregroundColor(Color("green"))
                        .fontWeight(.heavy)
                })
            }
            .padding(.vertical)
        }
        .background(Color("bg"))
        .edgesIgnoringSafeArea(.all)
        .animation(.easeOut)
    }
    
    // Getting BioMetricType...
    func getBioMetricStatus() -> Bool {
        let scanner = LAContext()
        if email == user && scanner.canEvaluatePolicy(.deviceOwnerAuthentication, error: .none) {
            return true
        }
        return false
    }
    
    func authenticateUser() {
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock \(email)") { (status, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            withAnimation(.easeOut) { logged = true }
        }
    }
}

