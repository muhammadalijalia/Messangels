//
//  FuneralOutfit.swift
//  Messangel
//
//  Created by Saad on 10/20/21.
//

import SwiftUI

struct FuneralOutfit: View {
    @State private var showNote = false
    @State private var note = ""
    @ObservedObject var vm: FeneralViewModel
    var body: some View {
        FuneralNoteView(tab: 1, stepNumber: 11.0, totalSteps: 12.0, showNote: $showNote, note: $vm.funeral.outfit_note, menuTitle: "Choix funéraires", title: "Indiquez si vous souhaitez porter une tenue en particulier", destination: AnyView(FuneralTakeWithObjects(vm: vm)))
    }
}
