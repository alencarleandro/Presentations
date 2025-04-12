import Foundation
import Speech
import AVFoundation

class SpeechRecognizerManager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    @Published var transcribedText: String = ""
    @Published var isRecording: Bool = false
    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined

    private var recordingID: String = ""
    private var timer: Timer?
    private var latestText: String = ""

    override init() {
        super.init()
        speechRecognizer?.delegate = self
        requestAuthorization()
    }

    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                self.authorizationStatus = authStatus
            }
        }
    }

    func startRecording(codigo : String) throws {
        recognitionTask?.cancel()
        self.recognitionTask = nil
        latestText = ""

        // Código fixo ou gerado
        recordingID = codigo // pode mudar se quiser algo dinâmico

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Não foi possível criar a requisição de reconhecimento.")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                let newText = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self.transcribedText = newText
                    self.latestText = newText
                }
            }

            if error != nil || (result?.isFinal ?? false) {
                self.stopRecording()
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, _) in
            self?.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true

        // Inicia o timer para enviar PUT a cada 10 segundos
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateDoc(with: self.latestText)
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
        timer?.invalidate()
        timer = nil
    }

    private func updateDoc(with text: String) {
        guard let url = URL(string: "http://192.168.128.9:1880/putPresentationsText") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "code": recordingID,
            "text_transcription": text
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Erro ao atualizar documento: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                print("Status da atualização: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}
