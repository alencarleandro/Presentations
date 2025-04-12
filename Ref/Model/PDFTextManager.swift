import Foundation
import PDFKit
import AVFoundation

class PDFTextManager: ObservableObject {
    @Published var currentPageIndex: Int = 0
    @Published var currentPageText: String = ""
    @Published var pageCount: Int = 0

    private var pdfDocument: PDFDocument?
    private let synthesizer = AVSpeechSynthesizer()

    func loadPDF(from urlString: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            completion(false)
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { [weak self] tempLocalUrl, response, error in
            guard let self = self, let tempLocalUrl = tempLocalUrl, error == nil else {
                print("Erro ao baixar o PDF: \(error?.localizedDescription ?? "Erro desconhecido")")
                completion(false)
                return
            }

            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsURL.appendingPathComponent("documento.pdf")

            do {
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.copyItem(at: tempLocalUrl, to: destinationURL)

                if let document = PDFDocument(url: destinationURL) {
                    DispatchQueue.main.async {
                        self.pdfDocument = document
                        self.pageCount = document.pageCount
                        self.updateCurrentPageText()
                        completion(true)
                    }
                } else {
                    print("Erro ao carregar o PDF")
                    completion(false)
                }
            } catch {
                print("Erro ao copiar o arquivo: \(error.localizedDescription)")
                completion(false)
            }
        }
        task.resume()
    }

    func goToNextPage() {
        guard currentPageIndex + 1 < pageCount else { return }
        currentPageIndex += 1
        updateCurrentPageText()
    }

    func goToPreviousPage() {
        guard currentPageIndex > 0 else { return }
        currentPageIndex -= 1
        updateCurrentPageText()
    }

    private func updateCurrentPageText() {
        guard let page = pdfDocument?.page(at: currentPageIndex) else {
            currentPageText = ""
            return
        }
        currentPageText = page.string ?? "(sem texto)"
    }

    func readCurrentPageText() {
        let utterance = AVSpeechUtterance(string: currentPageText)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        synthesizer.speak(utterance)
    }
}
