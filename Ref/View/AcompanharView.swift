import SwiftUI

struct AcompanharView: View {
    var my_presentations: [Presentation] // Recebe a lista de apresentações
    var paleta: ColorPalette?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [paleta!.background1, paleta!.background2]),
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    Image("presentationsLogo")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .accessibilityLabel("Logo")

                    Spacer()

                    ScrollView {
                        
                        VStack {
                            
                            ForEach(my_presentations, id: \._id) { palestra in
                                Text(palestra.title)
                                    .font(.headline)
                                    .frame(maxWidth: 300)
                                    .shadow(color: .white, radius: 1)
                                    .shadow(color: .white, radius: 1)
                                    .shadow(radius: 5)
                                    .accessibilityLabel("Palestra  \(palestra.title)")
                                
                                NavigationLink(destination: DescricaoView(palestra: palestra, paleta: paleta)) {
                                    Text("Descrição da palestra")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: 300)
                                        .background(paleta!.buttonColor)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                } // Fim NavigationLink
                                .accessibilityLabel("Botão de Descrição da Palestra")
                                .accessibilityHint("Acesso à uma descrição em texto e em áudio da apresentação")

                                NavigationLink(destination: TranscricaoView(palestra: palestra, paleta: paleta)) {
                                    Text("Transcrição da Palestra")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: 300)
                                        .background(paleta!.buttonColor)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                } // Fim NavigationLink
                                .padding(.bottom, 35)
                                .accessibilityLabel("Botão de Transcrição da Palestra")
                                
                            } // Fim ForEach
                            
                        } // Fim VStack
                        
                        
                    } // Fim ScrollView
                    

                } // Fim VStack
            } // Fim ZStack
        }
    }
}

#Preview {
    AcompanharView(my_presentations: [
        Presentation(_id: nil, _rev: nil, code: "aaaa", title: "title1", author: "author1", pdf_url: "url1"),
        Presentation(_id: nil, _rev: nil, code: "bbbb", title: "title2", author: "author2", pdf_url: "url2")
    ], paleta: paleta1)
}
