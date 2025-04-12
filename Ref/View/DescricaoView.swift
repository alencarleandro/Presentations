import SwiftUI

struct DescricaoView: View {
    var palestra: Presentation
    var paleta: ColorPalette?

    @StateObject private var pdfManager = PDFTextManager()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [paleta?.background1 ?? .white, paleta?.background2 ?? .gray]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                Image("presentationsLogo")
                    .resizable()
                    .frame(width: 100, height: 100)

                Text(palestra.title)
                    .font(.title)
                    .foregroundColor(paleta?.textColor ?? .black)
                    .bold()

                HStack {
                    
                    Spacer()
                    
                    Text("Apresentador: \(palestra.author)")
                        .padding(.leading, 55)
                        .font(.subheadline)
                        .foregroundColor(paleta?.textColor ?? .black)
                        .accessibilityLabel("Apresentador: \(palestra.author)")
                    
                    Spacer()
                    
                    Button {
                        // Função
                        pdfManager.readCurrentPageText()
                    } label: {
                        Image(systemName: "volume.2.fill")
                            .foregroundStyle(paleta?.textColor ?? .black)
                            .font(.title)
                            .padding(10)
                            .background(.white)
                            .cornerRadius(70)
                    } // Fim Button
                    .accessibilityLabel("Botão para falar Descrição da página")
                    
                    
                } // Fim HStack

                Divider().background(paleta?.textColor ?? .black)

                Text("Descrição:")
                    .font(.headline)
                    .foregroundColor(paleta?.textColor ?? .black)

                Text("Texto extraído da página atual:")
                    .font(.subheadline)
                    .foregroundColor(paleta?.textColor ?? .black)

                Text("Página \(pdfManager.currentPageIndex + 1) de \(pdfManager.pageCount)")
                    .font(.footnote)
                    .foregroundColor(paleta?.textColor ?? .black)

                ScrollView {
                    Text(pdfManager.currentPageText)
                        .foregroundColor(paleta?.textColor ?? .black)
                        .padding()
                } // Fim ScrollView
                .frame(height: 175)
                .accessibilityLabel("Texto extraído da página")

                HStack(spacing: 40) {
                    Button(action: {
                        pdfManager.goToPreviousPage()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .foregroundColor(paleta?.textColor ?? .black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: paleta!.background1, radius: 3)
                    } // Fim Button
                    .disabled(pdfManager.currentPageIndex == 0)
                    .accessibilityLabel("Ir para a página anterior")

                    Button(action: {
                        pdfManager.goToNextPage()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .foregroundColor(paleta?.textColor ?? .black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: paleta!.background1, radius: 3)
                    } // Fim Button
                    .disabled(pdfManager.currentPageIndex + 1 >= pdfManager.pageCount)
                    .accessibilityLabel("Ir para a próxima página")
                    
                } // Fim HStack

                NavigationLink(destination: TranscricaoView(palestra: palestra, paleta: paleta)) {
                    Text("Ver Transcrição")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 300)
                        .background(paleta?.buttonColor ?? .blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } // Fim NavigationLink
                .accessibilityLabel("Acessar Transcrição da Apresentação")

                Spacer()
            }
            .padding()
            .onAppear {
                // Carrega o PDF da palestra ao abrir a tela
                let urlString = palestra.pdf_url
                    
                pdfManager.loadPDF(from: urlString) { success in
                        if !success {
                            print("Erro ao carregar o PDF da palestra.")
                        }
                    }
                
            }
        }
    }
}

#Preview {
    DescricaoView(palestra: Presentation(_id: nil, _rev: nil, code: "aaaa", title: "title", author: "author", pdf_url: "url"), paleta: paleta1)
}
