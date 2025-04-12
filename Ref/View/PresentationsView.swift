import SwiftUI

// Struct personalizada para definir paleta de cores
struct ColorPalette: Hashable {
    var name: String
    var background1: Color
    var background2: Color
    var buttonColor: Color
    var textColor: Color
}

// Definição de paletas de cores
let paleta1 = ColorPalette(
    name: "Azul Clássico",
    background1: Color(red: 0.5, green: 0.80, blue: 0.9),
    background2: Color.white,
    buttonColor: Color(red: 0.45, green: 0.30, blue: 0.45),
    textColor: Color.black
)

let paleta2 = ColorPalette(
    name: "Algodão Doce",
    background1: Color(red: 1.00, green: 0.75, blue: 0.79),
    background2: Color.white,
    buttonColor: Color(red: 0.15, green: 0.80, blue: 0.95),
    textColor: Color.black
)

let paleta3 = ColorPalette(
    name: "Verde Floresta",
    background1: Color(red: 0.30, green: 0.60, blue: 0.30),
    background2: Color(red: 0.85, green: 0.95, blue: 0.85),
    buttonColor: Color(red: 0.20, green: 0.40, blue: 0.25),
    textColor: Color.black
)

let paletaMateus = ColorPalette(
    name: "Vermelho Pôr de Sol",
    background1: Color(red: 0.90, green: 0.05, blue: 0.10),
    background2: Color(red: 1.00, green: 0.60, blue: 0.20),
    buttonColor: Color(red: 0.35, green: 0.05, blue: 0.55),
    textColor: Color.black
)

let paletaCafe = ColorPalette(
    name: "Café Latte",
    background1: Color(red: 0.85, green: 0.75, blue: 0.70), // Bege médio (tipo cappuccino)
    background2: Color(red: 0.96, green: 0.91, blue: 0.84), // Bege claro (tipo latte)
    buttonColor: Color(red: 0.44, green: 0.2, blue: 0.1), // Marrom escuro (café)
    textColor: Color(red: 0.20, green: 0.13, blue: 0.08) // Quase preto, mas marrom profundo
)

let paletaCeu = ColorPalette(
    name: "Céu Natural",
    background1: Color(red: 0.20, green: 0.45, blue: 0.8),
    background2: Color(red: 0.50, green: 0.85, blue: 1.0),
    buttonColor: Color(red: 0.05, green: 0.60, blue: 0.40),
    textColor: Color.black
)

struct PresentationsView: View {
    @State private var showLaunchScreen = true
    @State var paleta: ColorPalette = paleta1
    let temas = [paleta1, paleta2, paleta3, paletaMateus, paletaCafe, paletaCeu]
    
    @State var presentations: [Presentation] = [] // Lista de apresentações
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        if showLaunchScreen {
            LaunchScreenView(paleta: paleta)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showLaunchScreen = false
                    }
                }
        } else {
            NavigationStack {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [paleta.background1, paleta.background2]),
                                   startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                    
                    ScrollView(.vertical) {
                        
                        VStack(spacing: 15) {
                            Image("presentationsLogo")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .accessibilityLabel("Logo")
                            
                            Text("Acessar:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(paleta.textColor)
                                .font(.title)
                                .fontWeight(.bold)
                                .shadow(radius: 10)
                                .padding(.leading, 15)
                            
                            Spacer()
                            
                            NavigationLink(destination: AcompanharView(my_presentations: presentations, paleta: paleta)) {
                                Text("Acompanhar Apresentação")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: 300)
                                    .background(paleta.buttonColor)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            } // Fim NavigationLink
                            .accessibilityLabel("Botão para Acompanhar Apresentação")
                            
                            NavigationLink(destination: CriarView(presentations: $presentations, paleta: paleta)) {
                                Text("Criar Apresentação")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: 300)
                                    .background(paleta.buttonColor)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            } // Fim NavigationLink
                            .accessibilityLabel("Botão para Criar Apresentação")
                            
                            
                            // Lista de apresentações criadas
                            VStack {
                                Text("Minhas Palestras:")
                                    .font(.headline)
                                    .foregroundColor(paleta.textColor)
                                    
                                
                                ForEach(presentations, id: \._id) { pres in
                                    VStack {
                                        NavigationLink(destination: GravarPalestraView(palestra: pres, paleta: paleta)) {
                                            Text(pres.title)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: 300)
                                                .background(paleta.buttonColor)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                        } // Fim NavigationLink
                                    } // Fim VStack
                                    .padding(.horizontal)
                                    .accessibilityLabel("Botão para selecionar Apresentação")
                                    .accessibilityHint("Apresentação: \(pres.title)")
                                    
                                } // Fim ForEach
                                
                            } // Fim VStack
                            
                            Spacer()
                            
                            // Escolha de Temas com layout personalizado
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Tema:")
                                    .font(.headline)
                                    .foregroundColor(paleta.textColor)
                                    .padding(.horizontal)

                                NavigationLink(destination: SelecionarTemaView(paleta: $paleta, temas: temas)) {
                                    HStack {
                                        Text("Tema")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(paleta.name)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color(.darkGray))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top, 30)

                            
                            

                            } // Fim VStack

                        } // Fim ScrollView
                } // Fim ZStack
            } // Fim NavigationStack
            .tint(.blue)
            .onAppear() {
                viewModel.fetch()
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    presentations = viewModel.apresentacoes
                } // Fim Timer
                Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                    presentations = viewModel.apresentacoes
                } // Fim Timer
                
                Timer.scheduledTimer(withTimeInterval: 6.5, repeats: true) { _ in
                    viewModel.fetch()
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        presentations = viewModel.apresentacoes
                    } // Fim Timer
                } // Fim Timer
                
            } // Fim onAppear
            
            
        }
        } // Fim body
    }

struct SelecionarTemaView: View {
    @Binding var paleta: ColorPalette
    let temas: [ColorPalette]

    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [paleta.background1, paleta.background2]),
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            List {
                ForEach(temas, id: \.self) { tema in
                    Button(action: {
                        paleta = tema
                    }) {
                        HStack {
                            Text(tema.name)
                                .foregroundColor(.white)
                            Spacer()
                            if tema == paleta {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(paleta.buttonColor)
                        .cornerRadius(8)
                    }
                    .listRowBackground(Color.clear) // Evita sobreposição de cor padrão da lista
                } // Fim ForEach
                
                
            } // Fim List
            
        } // Fim ZStack

        .scrollContentBackground(.hidden) // Remove fundo da lista no iOS 16+
        .navigationTitle("Selecionar Tema")
    }
}


#Preview {
    PresentationsView()
}
