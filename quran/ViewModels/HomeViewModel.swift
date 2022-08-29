//
//  HomeViewModel.swift
//  quran
//
//  Created by developer on 5/13/22.
//

import SwiftUI

extension HomeView {
    
    final class ViewModel: ObservableObject {
        
        @Published var showUserProfilePopUpView: Bool = false
        
        @AppStorage("user-profile-name") var userProfileName = "Moteallem Al Quran"
        @Published var userProfileNameEditing: String = ""
        
        @Published var selectedContentTab = "Verse"
        
        @AppStorage("user-last-surah") var userLastSurah: String = ""
        @AppStorage("user-last-ayah") var userLastAyah: Int = -1
        
    }
    
}
