//
//  ViewController.swift
//  MusicPlayer
//
//  Created by julio on 20/12/15.
//  Copyright © 2015 julio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, AVAudioPlayerDelegate {

    // MARK: - VARIABLES -
    
    enum paises: String {
        case Argentina = "Argentina",
        Francia = "Francia",
        Mexico = "México",
        Peru = "Peru",
        Spain = "España",
        Venezuela = "Venezuela"
    }
    
    let sonidos = [
        "A-argentina",
        "A-france",
        "A-mexico",
        "A-peru",
        "A-spain",
        "A-venezuela"
    ]
    
    let banderas = [
        "A-argentina",
        "A-france",
        "A-mexico",
        "A-peru",
        "A-spain",
        "A-venezuela"
    ]
    
    var player: AVAudioPlayer!
    var sonidoURL: NSURL?
    var volumenSet: Float = 50.0
    var shuffleON = false
    
    // MARK: - Outlets -
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var volumen: UISlider!
    @IBOutlet weak var shuffle: UISwitch!
    
    
    // MARK: - Actions -
    
    @IBAction func play(sender: AnyObject) {
        if player != nil && !player.playing {
            player.play()
        }
    }
    
    @IBAction func pause(sender: AnyObject) {
        if player != nil && player.playing {
            player.pause()
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        shuffleON = false
        shuffle.on = false
        image.image = UIImage(named: "musics")
        if player != nil && player.playing {
            player.stop()
            player.currentTime = 0.0
        }
        
        picker.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func volumen(sender: AnyObject) {
        volumenSet = sender.value
        if player != nil  {
            player.volume = volumenSet / 100
        }
    }
    
    @IBAction func shuffle(sender: AnyObject) {
        if player == nil || !player.playing {
            print("shuffle ON")
            shuffleON = true
            playPos(randomNumber())
            shuffle.on = true
        }
    }
    
    // MARK: - AVAudioPlayerDelegate -
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if shuffleON {
            let play = randomNumber()
            print("continue: \(play)")
            playPos(play)
        } else {
            print("finished")
            
        }
    }
    
    func randomNumber(range: Range<Int> = 0...5) -> Int {
        let min = range.startIndex
        let max = range.endIndex
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    // MARK: - auxiliar -
    
    func playPos(row: Int) {
        image.image = UIImage(named: banderas[row-1])
        picker.selectRow(row, inComponent: 0, animated: true)
        
        sonidoURL = NSBundle.mainBundle().URLForResource(sonidos[row-1], withExtension: "mp3")
        do {
            try player = AVAudioPlayer(contentsOfURL: sonidoURL!)
            player.delegate = self
            player.volume = volumenSet / 100
            
        } catch _ { }
        if !player.playing {
            player.play()
        }
    }
    
    // MARK: - Controller lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
    }
    
    // MARK: - UIPickerViewDelegate -
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            image.image = UIImage(named: "musics")
            sonidoURL = nil
            shuffleON = false
            shuffle.on = false
            if player.playing {
                player.stop()
                player.currentTime = 0.0
            }
        } else {
            playPos(row)
        }
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "Seleccione un País"
        case 1:
            return paises.Argentina.rawValue
        case 2:
            return paises.Francia.rawValue
        case 3:
            return paises.Mexico.rawValue
        case 4:
            return paises.Peru.rawValue
        case 5:
            return paises.Spain.rawValue
        case 6:
            return paises.Venezuela.rawValue
        default:
            return ""
        }
    }

}

