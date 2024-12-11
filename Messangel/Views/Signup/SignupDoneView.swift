//
//  SignupDoneView.swift
//  Messengel
//
//  Created by Saad on 5/7/21.
//

import SwiftUI

struct SignupDoneView: View {
    @EnvironmentObject var auth: Auth
    @EnvironmentObject var subVM: SubscriptionViewModel
    @State private var offset: CGFloat = 200
    var user: User

    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer().frame(height: 50)
                Image("logo_only")
                Spacer().frame(height: 50)
                Rectangle()
                    .frame(width: 60, height: 60)
                    .cornerRadius(25)
                    .overlay(
                        Image("done-check")
                    )
                    .scaleEffect(offset == 200 ? 0.5 : 1.0)
                Text("Votre profil a été créé !")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                Text(
                """
                Vous pouvez démarrer. Consultez votre adresse mail pour valider votre compte dès que possible.
                """
                )
                Spacer()
                Button("Démarrer", action: {
                    withAnimation {
                        self.auth.user = user
                        self.auth.updateUser()
                        self.subVM.checkSubscription()
                    }
                })
                    .buttonStyle(MyButtonStyle())
                    .accentColor(.black)
                .offset(y: offset)
                .animate {
                    offset = 0
                }
                Spacer().frame(height: 50)
            }.padding()
        }
        .foregroundColor(.white)
    }
}

//struct SignupDoneView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignupDoneView()
//    }
//}
