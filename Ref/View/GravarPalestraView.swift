import SwiftUI

struct GravarPalestraView: View {
    var palestra: Presentation
    var paleta: ColorPalette?
    
    @StateObject private var speechManager = SpeechRecognizerManager()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [paleta?.background1 ?? .white, paleta?.background2 ?? .gray]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Image("presentationsLogo")
                    .resizable()
                    .frame(width: 170, height: 170)
                
                Text(palestra.title)
                    .font(.title)
                    .foregroundColor(paleta?.textColor ?? .black)
                    .bold()
                    .padding()
                
                Divider().background(paleta?.textColor ?? .black)
                
                Text("Transcrição da Palestra:")
                    .font(.headline)
                    .foregroundColor(paleta?.textColor ?? .black)
                    .padding()
                
                TextEditor(text: $speechManager.transcribedText)
                    .padding()
                    .frame(height: 250)
                    .border(Color.gray)

                Spacer()
                
                Button(action: toggleRecording) {
                    Text(speechManager.isRecording ? "Parar Gravação" : "Iniciar Gravação")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(paleta?.buttonColor ?? .blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 50)
                .disabled(speechManager.authorizationStatus != .authorized)
                .accessibilityLabel(speechManager.isRecording ? "Parar Gravação" : "Iniciar Gravação")
                .accessibilityHint(speechManager.isRecording ? "Parar gravação atual" : "Iniciar Gravação para a palestra \(palestra.title)")
                
            }
            .padding()
        }
    }
    
    func toggleRecording() {
        if speechManager.isRecording {
            speechManager.stopRecording()
        } else {
            try? speechManager.startRecording(codigo: palestra.code)
        }
    }
}

#Preview {
    GravarPalestraView(palestra: Presentation(_id: nil, _rev: nil, code: "aaaa", title: "title", author: "author", pdf_url: "url"), paleta: paleta1)
}
