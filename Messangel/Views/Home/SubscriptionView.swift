//
//  SubscriptionView.swift
//  Messangel
//
//  Created by Saad on 5/17/21.
//

import SwiftUI
import NavigationStack
import Combine

struct SubscriptionView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var vm: SubscriptionViewModel
    @State private var cardNo = ""
    @State private var cardDOE = ""
    @State private var cardCVC = ""
    @State private var valid = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            VStack(spacing: 0.0) {
                Color.accentColor
                    .ignoresSafeArea()
                    .frame(height: 5)
                NavBar()
                    .overlay(HStack {
                        BackButton()
                        Spacer()
                        Text("Souscription abonnement")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
//                        Button(action: {}, label: {
//                            Image("help")
//                                .padding(.horizontal, -30)
//                        })
                    }
                    .padding(.trailing, 5)
                    .padding(.leading))
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            CreditCardView(cardNo: $cardNo, cardDOE: $cardDOE, cardCode: $cardCVC)
                            SubscriptionDetailsView()
                        }
                        .padding()
                        .textFieldStyle(MyTextFieldStyle())
                    }
                    HStack {
                        Button(action: {
                            if !valid {
                                return
                            }
                            vm.subscription.card?.number = Int(cardNo) ?? 0
                            vm.subscription.card?.cvc = Int(cardCVC) ?? 0
                            vm.subscription.card?.expMonth = Int(cardDOE.components(separatedBy: "/")[0]) ?? 0
                            vm.subscription.card?.expYear = Int(cardDOE.components(separatedBy: "/")[1]) ?? 0
                            vm.subscribe { success in
                                if success {
                                    vm.checkSubscription()
                                    navigationModel.popContent(TabBarView.id)
                                }
                            }
                        }, label: {
                            Text("Valider mon paiement et accepter les CGU")
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        })
                            .buttonStyle(MyButtonStyle(padding: 60, foregroundColor: .white, backgroundColor: valid ? .accentColor : .gray, cornerRadius: 30))
                        .padding(.vertical, 30)
                    }
                    
                    .frame(maxWidth: .infinity)
                    .background(
                        Color.white
                            .clipShape(CustomCorner(corners: [.topLeft,.topRight]))
                    )
                    .shadow(color: Color.gray.opacity(0.15), radius: 5, x: -5, y: -5)
                }}
                .edgesIgnoringSafeArea(.bottom)
        }
        .onReceive(Just(cardDOE)) { inputValue in
            if inputValue.count > 5 {
                cardDOE.removeLast()
            }
        }
        .onReceive(Just(cardCVC)) { inputValue in
            if inputValue.count > 3 {
                cardCVC.removeLast()
            }
        }
        .onChange(of: cardNo) { value in
            validate()
        }
        .onChange(of: cardDOE) { value in
            validate()
        }
        .onChange(of: cardCVC) { value in
            validate()
        }
    }
    
    func validate()  {
        valid = !cardNo.isEmpty && !cardDOE.isEmpty && !cardCVC.isEmpty
    }
}

struct CreditCardView: View {
    @Binding var cardNo: String
    @Binding var cardDOE: String
    @Binding var cardCode: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Montant TTC à régler")
                .font(.system(size: 20))
                .fontWeight(.bold)
            Divider()
            Text("2,00€")
                .foregroundColor(.accentColor)
                .font(.system(size: 28))
                .fontWeight(.bold)
            Text("Puis 2€/mois sans engagement*")
                .foregroundColor(.secondary)
                .font(.system(size: 15))
                .padding(.bottom)
            Text("Informations de paiement")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(.bottom)
            TextField("Numéro de carte bancaire", text: $cardNo)
                .keyboardType(.numberPad)
                .normalShadow()
                .padding(.bottom)
            TextField("Date d’expiration (MM/YY)", text: $cardDOE)
                .keyboardType(.numbersAndPunctuation)
                .normalShadow()
                .padding(.bottom)
            TextField("Code de sécurité (3 chiffres)", text: $cardCode)
                .keyboardType(.numbersAndPunctuation)
                .normalShadow()
                .padding(.bottom)
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(Color.gray.opacity(0.5))
                .frame(height: 160)
                .overlay(
                    VStack {
                        HStack(alignment: .top) {
                            Image("lock")
                            Text("Selon votre établissement bancaire, une redirection vers la page d’authentification de votre banque pourrait avoir lieu pour terminer la validation de votre paiement.")
                                .font(.system(size: 13))
                        }
                        .padding()
                        HStack {
                            Image("master-card")
                            Image("secure-payment")
                            Image("visa-secure")
                        }
                        .padding(.bottom)
                    })
                .padding(.bottom)
        }
    }
}

struct SubscriptionDetailsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Inclus dans votre abonnement :")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(.bottom)
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
                Text("Désignation de vos Anges-gardiens : ces personnes transmettront votre Messangel.")
            }
            .padding(.bottom)
            HStack {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
                Text("Conservation de vos données Messangel sur nos serveurs sécurisés, sans limite de temps.")
            }
            .padding(.bottom)
            Text(notes)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .padding(.bottom)
            HStack {
                Spacer()
                Image("visa-card-footer")
                Spacer()
            }
            HStack() {
                Spacer()
                Image("lock")
                    .renderingMode(.template)
                Text("Paiement sécurisé")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom, 150)
        }
    }
}

//struct SubscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionView()
//    }
//}

private var notes = """
    * Vous serez prélevé de 2,00€ dès validation de votre moyen de paiement, puis de 2,00€ tous les mois suivants, à date de souscription de votre abonnement. Ce prélèvement automatique a lieu tous les mois, sans limite de temps. Vous pouvez annuler ce prélèvement automatique à tout moment en revenant sur cette page, au plus tôt 24h après la souscription et au plus tard 48h avant la date d’échéance du Pass en cours. Vos données seront alors conservées 2 mois avant suppression.
    
    Tous les prix incluent la TVA.
    
    Conformément à l’article L 121-21 du Code de la Consommation, vous disposez d’un délai de quatorze jours francs à compter de la souscription de votre abonnement pour exercer votre droit de rétractation. Pour plus d’information, cliquez ici pour voir nos Conditions Générales d’Utilisation.
    
    Pour voir notre Politique de confidentialité, cliquez ici.
    
    La société Messangel adhère au Service du Médiateur du e-commerce de la FEVAD. Pour connaître les modalités de saisine du Médiateur, cliquez ici.
    
    Messangel est une société basée en France.
    """
