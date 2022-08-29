//
//  quranApp.swift
//  quran
//
//  Created by developer on 5/13/22.
//  - initial Creation Date by developer on 4/30/22.
//  so many changes occured upon this time.
//  + project development assets:
//  -   design by: Tanvir Ahassan - UX Designer https://www.figma.com/@tanvirux
//  -   design figma resource: https://www.figma.com/community/file/966921639679380402
//  -   data by: https://salamquran.com
//  -   verse-by-verse quran by: https://everyayah.com/


import SwiftUI

@main
struct quranApp: App {
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .statusBar(hidden: true)
        }
    }
}
