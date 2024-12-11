//
//  MessagesView.swift
//  Messangel
//
//  Created by Saad on 5/27/21.
//

import SwiftUI
import NavigationStack

let newGroupMessage = "Exemple : « Famille », « Mes amis proches », « Pour ma femme »"

//struct MessagesBottomView: View {
//    @EnvironmentObject var navigationModel: NavigationModel
//    @StateObject private var vm = GroupViewModel()
//    @State private var loading = false
//    @State private var showNewGroupBox = false
//
//    var body: some View {
//        ZStack {
//            if showNewGroupBox {
//                InputAlert(title: "Donnez un nom au groupe", message: newGroupMessage) { result in
//                    showNewGroupBox.toggle()
//                    if let text = result {
//                        if !text.isEmpty && text.count > 2 {
//                            vm.group.name = text
//                            vm.group.user = getUserId()
//                            vm.create { success in
//                                print("Group \(text) created: \(success)")
//                                    if success {
//                                        vm.getAll()
//                                    }
//                            }
//                        }
//                    }
//                }
//                .zIndex(1.0)
//            }
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    Text("Créer un message")
//                        .fontWeight(.bold)
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            navigationModel.pushContent(TabBarView.id) {
//                                VideoRecoderView()
//                                    .environmentObject(vm)
//                            }
//                        }) {
//                            AddMessageView(text: "Vidéo", image: "ic_video")
//                        }
//                        Button(action: {
//    //                        loading = true
//    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//    //                            let editor = RichEditorView(frame: .zero)
//    //                            loading = false
//                                 navigationModel.pushContent(TabBarView.id) {
//                                    TextEditorView()
//                                        .environmentObject(vm)
//                                 }
//    //                        }
//                        }) {
//                            AddMessageView(text: "Texte", image: "ic_text")
//                        }
//                        .overlay(Group {
//                            if loading {
//                                Loader()
//                            }
//                        })
//                        Button(action: {
//                            navigationModel.pushContent(TabBarView.id) {
//                                AudioRecorderView()
//                                    .environmentObject(vm)
//                            }
//                        }) {
//                            AddMessageView(text: "Audio", image: "ic_audio")
//                        }
//                        Spacer()
//                    }
//                    Text("Destinataires")
//                        .fontWeight(.bold)
//                    CreateGroupView(showNewGroupBox: $showNewGroupBox)
//                    VStack {
//                        ForEach(vm.groups, id: \.self) { group in
//                           GroupCapsule(group: group)
//                        }
//                    }
//                    Spacer().frame(height: 50)
//                }
//                .padding()
//            }
//            .task() {
//                vm.getAll()
//            }
//        }
//
//    }
//}

struct AddMessageView: View {
    var text = ""
    var image = ""
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .foregroundColor(.white)
            .frame(width: 108, height: 180)
            .normalShadow()
            .overlay(VStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 56, height: 56)
                    .foregroundColor(.accentColor)
                    .overlay(Image(image))
                Text(text)
                    .foregroundColor(.black)
                Spacer().frame(height: 30)
                Image(systemName: "plus")
                    .foregroundColor(.accentColor)
            })
    }
}

struct CreateGroupView: View {
    var width = 0
    @Binding var showNewGroupBox: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .foregroundColor(.white)
            .if(width > 0) {$0.frame(width: 340, height: 110)}
            .if(width == 0) {$0.frame(height: 110)}
            .normalShadow()
            .overlay(
                    HStack {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(Color.gray.opacity(0.2))
                            .frame(width: 56, height: 56)
                            .foregroundColor(.white)
                            .overlay(Image(systemName: "plus").foregroundColor(.gray.opacity(0.5)))
                        VStack(alignment: .leading, spacing: 7.0) {
                            Text("Créer un groupe")
                                .fontWeight(.bold)
                            Text("Créer un destinataire ou un groupe de destinataires.")
                                .foregroundColor(.secondary)
                                .font(.system(size: 13))
                        }
                    }
                    .onTapGesture {
                        showNewGroupBox.toggle()
                    }
                .padding(.horizontal, 20),
                alignment: .leading
            )
    }
}
