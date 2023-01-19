//
//  Video_EditorApp.swift
//  Video Editor
//
//  Created by Vladislav Mikheenko on 29.07.2022.
//

import SwiftUI
import AVKit

@main
struct Video_EditorApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()   
        }
    }
}


struct VideoView: View {
    
    var body: some View {
        
        if let wrapUrl = getUrl() {
            VideoPlayer(player: AVPlayer(url: wrapUrl))
        }
        
//                .frame(height: 400)
    }
    
    func getUrl() -> URL? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
             let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            
            return fileURLs.first
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            return nil
        }
    }
    
}
