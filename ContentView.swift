/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The vImage Pixel Buffer Video Effects content view file.
 */

import SwiftUI

struct ContentView: View {
    
    //    @EnvironmentObject var videoEffectsEngine: VideoEffectsEngine
    
    //    @State private var timeRemaining = 100
    //    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil
    @State var currentTime = 3
    
    @ObservedObject var videoEffectsEngine =  VideoEffectsEngine()
    
    @State var isRecording = false
    
    private var viewToRecord: some View {
        // some view with animation which we'd like to record as a video
        
        ZStack {
            VStack {
                if let wrapImg = videoEffectsEngine.outputImage {
                    Image(uiImage: wrapImg)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    //                        .padding(.horizontal, 2)
                }
                
                Spacer()
            }
            
            if !timerIsPaused {
                Rectangle()
                    .foregroundColor(.black.opacity(0.7))
                    .ignoresSafeArea()
                
                Text("\(currentTime)")
                    .foregroundColor(Color.white)
                    .font(.largeTitle.bold())
                    .ignoresSafeArea()
            }
            
            if videoEffectsEngine.showSucces {
                Rectangle()
                    .foregroundColor(.black.opacity(0.7))
                    .ignoresSafeArea()
                
                Text("Video Saved")
                    .foregroundColor(Color.white)
                    .font(.largeTitle.bold())
                    .ignoresSafeArea()
            }
        }
        
    }
    
    var body: some View {
        
        NavigationView {
            viewToRecord
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .background(
                    NavigationLink(isActive: $videoEffectsEngine.showGellary, destination: {
                        VideoListView()
                    }, label: {
                        EmptyView()
                    })
                )
                .toolbar {
                    Button("Gellary") {
                        videoEffectsEngine.showGellary = true
                        videoEffectsEngine.needRenderPreview = false
                    }
                }
                .onAppear() {
                    videoEffectsEngine.needRenderPreview = true
                }
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        let horizontalAmount = value.translation.width as CGFloat
                                      let verticalAmount = value.translation.height as CGFloat
                                      
                                      if abs(horizontalAmount) > abs(verticalAmount) {
                                          print(horizontalAmount < 0 ? "left swipe" : "right swipe")
                                          if horizontalAmount > 0 {
                                              guard timerIsPaused && videoEffectsEngine._captureState == .idle else { return }
                                              videoEffectsEngine.scanDirection = .horizontal
                                              startTimer()
//                                              videoEffectsEngine.catureVideo()
                                          }
                                      } else {
                                          print(verticalAmount < 0 ? "up swipe" : "down swipe")
                                          if verticalAmount > 0 {
                                              guard timerIsPaused && videoEffectsEngine._captureState == .idle else { return }
                                              videoEffectsEngine.scanDirection = .vertical
                                              startTimer()
//                                                                         videoEffectsEngine.catureVideo()
                                          }
                                      }
                    }))
            
        }
    }
    
    func startTimer(){
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            currentTime -= 1
            print("timer start \(currentTime)")
            
            guard currentTime > 0 else {
                stopTimer()
                videoEffectsEngine.catureVideo()
                return
            }
        }
    }
    
    func stopTimer(){
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
        currentTime = 3
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
