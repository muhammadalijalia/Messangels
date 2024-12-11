//
//  AdminDocs.swift
//  Messangel
//
//  Created by Saad on 11/18/21.
//

import SwiftUI
import NavigationStack

struct PracticalCodesOTP: View {
    @ObservedObject var vm: PracticalCodeViewModel
    @State private var otp = ""
    var body: some View {
        NavigationStackView("PracticalCodesOTP") {
            ZStack(alignment: .topLeading) {
                Color.accentColor
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        BackButton()
                        Spacer()
                    }
                    Spacer()
                    Image("ic_lock_white")
                        .padding(.bottom)
                    Text("Inscrivez le code reçu par SMS")
                        .foregroundColor(.white)
                        .font(.system(size: 17), weight: .bold)
                    OTPTextFieldView(code: $otp)
                    Spacer()
                    HStack {
                        Spacer()
                        NextButton(source: "PracticalCodesOTP", destination: AnyView(PracticalCodeName(vm: vm)), active: .constant(!otp.isEmpty))
                    }
                }.padding()
            }
            .foregroundColor(.white)
        }
    }
}
