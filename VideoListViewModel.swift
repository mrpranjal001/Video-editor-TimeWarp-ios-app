//
//  VideoListViewModel.swift
//  Video Editor
//
//  Created by Vladislav Mikheenko on 05.08.2022.
//

import Foundation

class VideoListViewModel: ObservableObject {
    
   @Published var videoURLs = [URL]()
    @Published var showVideoPreview = false
    var currentUrl: URL?
    
    init() {
        getUrls()
    }
    
    func getUrls() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            var fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            fileURLs.sort(by: {$0.path() > $1.path()})
            videoURLs = fileURLs
            
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
}
