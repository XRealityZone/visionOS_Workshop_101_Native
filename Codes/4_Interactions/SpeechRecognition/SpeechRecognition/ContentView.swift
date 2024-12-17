//
//  ContentView.swift
//  SpeechRecognition
//
//  Created by xuchi on 2024/8/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false

    var body: some View {
        NavigationStack {
            VStack {
                Toggle("Start / Stop Recognition", isOn: $isRecording)
                    .padding()
                    .onChange(of: isRecording) { newValue in
                        if newValue {
                            speechRecognizer.startTranscribing()
                        } else {
                            speechRecognizer.stopTranscribing()
                            print(speechRecognizer.transcript)
                        }
                    }
                Text(speechRecognizer.transcript)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(Color.gray.opacity(0.1))
            }
            .navigationTitle("Speech Recognizer")
        }
    }
}

struct RecordToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "mic.fill" : "mic.slash.fill")
                    .foregroundColor(configuration.isOn ? .green : .red)
                configuration.label
            }
            .padding()
            .background(configuration.isOn ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
            .cornerRadius(10)
        }
    }
}
