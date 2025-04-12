import Foundation
import Combine

class PDFViewModel: ObservableObject {
    @Published var currentPageText: String = ""
    @Published var currentPageIndex: Int = 0
    @Published var pageCount: Int = 0
    @Published var isLoading: Bool = false

    private var pdfManager = PDFTextManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Vincula os dados do PDFTextManager ao ViewModel
        pdfManager.$currentPageText
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentPageText)

        pdfManager.$currentPageIndex
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentPageIndex)

        pdfManager.$pageCount
            .receive(on: DispatchQueue.main)
            .assign(to: &$pageCount)
    }

    func downloadPDF(from urlString: String) {
        isLoading = true
        pdfManager.loadPDF(from: urlString) { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                if !success {
                    self?.currentPageText = "Erro ao carregar o PDF."
                }
            }
        }
    }

    func goToPreviousPage() {
        pdfManager.goToPreviousPage()
    }

    func goToNextPage() {
        pdfManager.goToNextPage()
    }

    func readCurrentPageText() {
        pdfManager.readCurrentPageText()
    }

    var canGoToPreviousPage: Bool {
        currentPageIndex > 0
    }

    var canGoToNextPage: Bool {
        currentPageIndex + 1 < pageCount
    }
}
