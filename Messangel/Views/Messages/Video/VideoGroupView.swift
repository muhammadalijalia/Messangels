//
//  DocGroupView.swift
//  Messangel
//
//  Created by Saad on 7/12/21.
//

import SwiftUI
import NavigationStack

struct VideoGroupView: View {
    @EnvironmentObject var navigationModel: NavigationModel
    @State private var selectedGroup = 0
    var filename: URL
    var selectedFilter: Color
    @State private var valid = false
    @State private var loading = false
    @State private var showNewGroupBox = false
    @ObservedObject var vm: VideoViewModel
    @EnvironmentObject var groupVM: GroupViewModel
    
    var body: some View {
        NavigationStackView("VideoGroupView") {
            ZStack {
                if loading {
                    RoundedRectangle(cornerRadius: 15.0)
                        .foregroundColor(.white)
                        .frame(width:236, height: 51)
                        .shadow(radius: 10)
                        .overlay(
                            Text("Vidéo enregistrée")
                                .font(.system(size: 17), weight: .semibold)
                                .foregroundColor(.accentColor)
                        )
                        .zIndex(1.0)
                }
                if showNewGroupBox {
                    InputAlert(title: "Donnez un nom au groupe", message: newGroupMessage) { result in
                        showNewGroupBox.toggle()
                        if let text = result {
                            if !text.isEmpty && text.count > 2 {
                                groupVM.group.name = text
                                groupVM.group.user = getUserId()
                                groupVM.create { success in
                                    print("Group \(text) created: \(success)")
                                        if success {
                                            groupVM.getAll()
                                        }
                                }
                            }
                        }
                    }
                    .zIndex(1.0)
                }
                ZStack(alignment: .bottom) {
                    if loading {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .zIndex(1.0)
                    }
                    MenuBaseView(height: 60, title: "Destinataires") {
                        Text("Aperçu")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                        ZStack {
                            VideoPreview(fileUrl: filename)
                                .frame(width: 211.99, height: 392.53)
                            Rectangle()
                                .foregroundColor(selectedFilter.opacity(0.15))
                                .frame(width: 211.99, height: 392.53)
                        }
                        .padding(.bottom)
                        Text("Choisir ou créer un groupe")
                            .font(.system(size: 17), weight: .semibold)
                            .padding(.bottom, -15)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0.0){
                                ForEach(groupVM.groups, id: \.self) { group in
                                    ZStack {
                                        if group.id == selectedGroup {
                                            RoundedRectangle(cornerRadius: 20.0)
                                                .stroke(Color.accentColor)
                                                .frame(width: 341, height: 111)
                                        }
                                        GroupCapsule(group: group, tappable: false, width: 339)
                                            .onTapGesture {
                                                selectedGroup = group.id
                                                if selectedGroup > 0 {
                                                    valid = true
                                                }
                                            }
                                            .padding()
                                    }
                                }
                                CreateGroupView(width: 339, showNewGroupBox: $showNewGroupBox)
                            }
                            .padding()
                        }
                        Spacer().frame(height: 20)
                    }                       
                        HStack {
                            Button(action: {
                                if selectedGroup > 0 {
                                    Task {
                                       await uploadVideo()
                                    }
                                }
                            }, label: {
                                Text("Valider")
                                    .font(.system(size: 15))
                                    .padding(3)
                            })
                            .buttonStyle(MyButtonStyle(foregroundColor: .white, backgroundColor: valid ? .accentColor : .gray))
                            .padding(.bottom, 50)
                            .padding(.top, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            Color.white
                                .clipShape(CustomCorner(corners: [.topLeft,.topRight]))
                        )
                        .shadow(color: Color.gray.opacity(0.15), radius: 5, x: -5, y: -5)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    func uploadVideo() async {
        do {
            let data = try Data(contentsOf: filename)
            loading.toggle()
            let response = await Networking.shared.upload(data, fileName: filename.lastPathComponent, fileType: "video")
            loading.toggle()
            if let response = response {
                DispatchQueue.main.async {
                    vm.uploadResponse = response
                    vm.video.video_link = response.files.first?.path ?? ""
                    vm.video.size = response.files.first?.size ?? 0
                    vm.video.group = selectedGroup
                    vm.create {
                        navigationModel.popContent(TabBarView.id)
                    }
                }
            }
            
        } catch let err {
            print(err)
        }
    }
}
