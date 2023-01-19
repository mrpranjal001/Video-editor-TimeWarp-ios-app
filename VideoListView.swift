//
//  VideoListView.swift
//  Video Editor
//
//  Created by Vladislav Mikheenko on 05.08.2022.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct VideoListView: View {
    
    @ObservedObject var viewModel = VideoListViewModel()
    
    var body: some View {
        
       
        VStack {
            
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    ForEach(viewModel.videoURLs, id: \.self) { url in
                        
                        Button {
                            print("url \(url)")
                            viewModel.currentUrl = url
                            viewModel.showVideoPreview = true
                        } label: {
                            VStack {
                                Image(systemName: "doc")
                                    .resizable()
                                    .frame(width: 40, height: 50)
                                
                                Text("\(url.absoluteString.suffix(33).prefix(29))".getFormatedDate() ?? "error Name")
//                                Text(url.absoluteString)
                            }
                        }

                        
                        
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle("Saved videos")
        .fullScreenCover(isPresented: $viewModel.showVideoPreview) {
            if let wrapUrl = viewModel.currentUrl {
                VideoPlayer(player: AVPlayer(url: wrapUrl))
            } else {
                Text("error video")
            }
            
        }
        
        
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView()
    }
}

extension String {
    
    func getFormatedDate() -> String? {
        print("self \(self)")
        let formatedStr = self.replacingOccurrences(of: "%20", with: " ")
        print("formated \(formatedStr)")
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yyyy HH:mm:ss"

        let date: Date? = dateFormatterGet.date(from: formatedStr)
//        print(dateFormatterPrint.string(from: date!))
        
        guard let wrapDate = date else {
            return nil
        }
        
        return dateFormatterPrint.string(from: wrapDate)
    }
    
}
