//
//  ListInteractor.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation
import Speech

protocol ListInteractorProtocol: AnyObject {
    var presenter: ListPresenterProtocol? { get set }
    var networkService: NetworkServiceProtocol? { get set }
    func getTasks(searchText: String?)
    func deleteTask(task: Task, completion: @escaping EmptyBlock)
    func startSpeechRecognition()
    func stopSpeechRecognition()
}

final class ListInteractor: ListInteractorProtocol {
    
    weak var presenter: ListPresenterProtocol?
    var networkService: NetworkServiceProtocol? = NetworkService()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-EN"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func getTasks(searchText: String? = nil) {
        if isFirstLaunch() {
            loadFromJson()
        } else {
            loadFromCoreData(searchText: searchText)
        }
    }
    
    func deleteTask(task: Task, completion: @escaping EmptyBlock) {
        CoreDataManager.shared.deleteElement(task: task, completion: completion)
    }
    
    private func loadFromCoreData(searchText: String? = nil) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let result = CoreDataManager.shared.fetchTasks(searchText: searchText)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.presenter?.didGetTasks(tasks: tasks)
                case .failure(let error):
                    self?.presenter?.showAlert(title: error.localizedDescription)
                }
            }
        }
    }
    
    private func loadFromJson() {
        networkService?.getTasks(completion: { [weak self] result in
            switch result {
            case .success(let dummyTasks):
                guard let dummyTasks else {
                    return
                }
                
                CoreDataManager.shared.saveDummyArray(tasks: dummyTasks) { [weak self] in
                    self?.loadFromCoreData()
                }
            case .failure(let error):
                self?.presenter?.showAlert(title: error.localizedDescription)
            }
        })
    }
    
    private func isFirstLaunch() -> Bool {
        let hasLaunchedKey = "hasLaunchedBefore"
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: hasLaunchedKey) {
            return false
        } else {
            userDefaults.set(true, forKey: hasLaunchedKey)
            return true
        }
    }
    
    func startSpeechRecognition() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            switch authStatus {
            case .authorized:
                self?.startRecording()
            case .denied, .restricted, .notDetermined:
                self?.presenter?.showAlert(title: .accessDenied)
            @unknown default:
                break
            }
        }
    }
    
    private func startRecording() {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            presenter?.showAlert(title: error.localizedDescription)
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            return
        }
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.presenter?.didRecognizeSpeech(text: result.bestTranscription.formattedString)
                }
            }
            
            if error != nil || result?.isFinal == true {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            recognitionRequest.append(buffer)
        }
        
        do {
            try audioEngine.start()
        } catch let error {
            presenter?.showAlert(title: error.localizedDescription)
        }
    }
    
    func stopSpeechRecognition() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}
