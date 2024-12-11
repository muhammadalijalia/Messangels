//
//  FuneralMusicNote.swift
//  Messangel
//
//  Created by Saad on 11/18/21.
//

import SwiftUI
import NavigationStack

struct AdminDocsNote: View {
    @State private var showNote = false
    @State private var loading = false
    @EnvironmentObject var navModel: NavigationModel
    @ObservedObject var vm: AdminDocViewModel
    var title = "Joignez des scans ou photos des documents avec l’outil note"
    
    fileprivate func createOrUpdateRecord() {
        if vm.updateRecord {
            vm.update(id: vm.adminDoc.id ?? 0) { success in
                if success {
                    navModel.popContent("AdminDocsList")
                    vm.getAll { _ in }
                }
            }
        } else {
            vm.create { success in
                if success && vm.adminDocs.isEmpty {
                    WishesViewModel.setProgress(tab: 13) { completed in
                        loading.toggle()
                        if completed {
                            navModel.pushContent(title) {
                                FuneralDoneView()
                            }
                        }
                    }
                } else {
                    loading.toggle()
                    if success {
                        navModel.pushContent(title) {
                            FuneralDoneView()
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        FuneralNoteAttachCutomActionView(totalSteps: 3.0, showNote: $showNote, note: $vm.adminDoc.document_note, loading: $loading, attachements: $vm.attachements, noteAttachmentIds: $vm.adminDoc.document_note_attachement, menuTitle: wishesExtras.first!.name, title: title) {
            loading.toggle()
            createOrUpdateRecord()
        }
    }
}
