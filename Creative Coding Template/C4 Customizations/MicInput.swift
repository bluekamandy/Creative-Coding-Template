import UIKit
import AVFoundation
import C4

class MicInput {
    
    // MARK: INSTANCE VARIABLES
    // These variables are availabe throughout WorkSpace
    
    // Variables related to the microphone.
    
    private var recorder: AVAudioRecorder!
    private var updated: ((Float) -> Void)?
    private let minDecibels: Float = -80
    
    private let settings: [String:Any] = [
        AVFormatIDKey: kAudioFormatLinearPCM,
        AVSampleRateKey: 44100,
        AVNumberOfChannelsKey: 1,
        AVLinearPCMBitDepthKey: 16,
        AVLinearPCMIsBigEndianKey: false,
        AVLinearPCMIsFloatKey: false
    ]
    
    // Change the multiplier to amplify the effect of sound on your shapes.
    // You can, optionally, create more than one multiplier.
    
    public let multiplier = 1.0 // Larger = bigger
    public var myVolume: Double! // Use this variable to control the size or position of your shapes.
    
    // MARK: SETUP
    
    static let shared = MicInput()
    
    private init() {
        
        
        // Set up the microphone to start listening.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print(error.description)
        }
        
        do {
            let url = URL(string: NSTemporaryDirectory().appending("tmp.caf"))!
            print("recording to")
            print(url)
            try recorder = AVAudioRecorder(url: url, settings: settings)
        } catch {
            print("error!")
        }
        
        // Start the microphone.
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
    }
    
    // MARK: MIC SIGNAL CONVERSION
    // Converting input from microphone to useful, human-readable numbers.
    
    var level: Float {
        
        let decibels = recorder.averagePower(forChannel: 0)
        
        if decibels < minDecibels {
            return 0
        } else if decibels >= 0 {
            return 1
        }
        
        let minAmp = powf(10, 0.05 * minDecibels)
        let inverseAmpRange = 1 / (1 - minAmp)
        let amp = powf(10, 0.05 * decibels)
        let adjAmp = (amp - minAmp) * inverseAmpRange
        
        return sqrtf(adjAmp)
        
    }
    
    var pos: Float {
        // linear level * by max + min scale (20 - 130db)
        return level * 130 + 20
    }
    
    // MARK: SAMPLE THE MICROPHONE AND CALL THE CHANGE SHAPE FUNCTION
    // Sample the microphone.
    
    @objc func updateMeter() {
        recorder.updateMeters()
        updated?(pos)
        myVolume = Double(self.pos)/2.0*self.multiplier
    }
    
    
    
    
}

