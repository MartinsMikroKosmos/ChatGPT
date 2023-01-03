//
//  ContentView.swift
//  ChatGPT
//
//  Created by Martin Richter on 16.12.22.
//

import SwiftUI
import CoreData
import OpenAISwift

private var apiKey = "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"

final class ViewModel: ObservableObject {
    init() {
    }
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: apiKey)
    }
    
    func send(text: String,
              completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text,
                               maxTokens: 500,
                               completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
            
        })
    }
}


//MARK: ContentView
struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            ForEach(models, id: \.self) {string in
                Text(string)
                    .bold()
            }
            
            Spacer()
            
            HStack {
                TextField("Frage Alfred...", text: $text)
                Button("Senden") {
                    send()
                }
            }
        }
        .onAppear {
            viewModel.setup()
        }
        .padding(.bottom, 0.2 )
        .padding(.leading)
        .padding(.trailing)
        .padding(.top)
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("Ich:\n \(text)\n")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("Alfred: "+response)
                self.text = ""
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
