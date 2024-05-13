//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Josselyn Estrella Lobos Palomino on 13/05/24.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var grabarButton: UIButton!
    @IBOutlet weak var reproducirbutton: UIButton!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var agregarButton: UIButton!
    
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    @IBAction func reproducirTapped(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
        }catch {}
    }
    @IBAction func grabarTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
            grabarAudio?.stop()
            grabarButton.setTitle("GRABAR", for: .normal)
            reproducirbutton.isEnabled = true
        }else{
            grabarAudio?.record()
            grabarButton.setTitle("DETENER", for: .normal)
            reproducirbutton.isEnabled = false
            agregarButton.isEnabled = true
        }
    }
    @IBAction func agregarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as!
                       AppDelegate).persistentContainer.viewContext
        let grabacion = Grabacion(context: context)
        grabacion.nombre = nombreTextField.text
        grabacion.audio = NSData(contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
            

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        reproducirbutton.isEnabled = false
        agregarButton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    func configurarGrabacion(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*********")
            print(audioURL!)
            print("*********")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
            
        }catch let error as NSError{
            print(error)
        }
    }

}
