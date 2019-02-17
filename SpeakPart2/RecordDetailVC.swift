//
//  RecordDetailVC.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/28.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class RecordDetailVC: UIViewController,AVAudioPlayerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countTimeLabel: UILabel!
    @IBOutlet weak var audioTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var audioPlayBtn: UIButton!

    var date: Date?
    var fileName = ""
    var audioplayer: AVAudioPlayer?
    var floatDate: TimeInterval = 0.0
    var recordFilePath = ""
    weak var audioTimer: Timer?
    var audioSeconds: Int = 0
    var audioDuration: TimeInterval = 0.0
    var isDraggingTimeSlider = false
    var save = false
    var isPlaying = false
    
    var exam = ExamList()
    var examList = [ExamList]()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Test Record"
        let image = #imageLiteral(resourceName: "back-1")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(RecordDetailVC.navigationBackBtnTap))
        navigationItem.leftBarButtonItem = backButton
        
        questionLabel.numberOfLines = 0
        
        // permission for audio player
        let instance = AVAudioSession.sharedInstance()
        if instance.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            instance.requestRecordPermission({ granted in
                if granted {
                    print("User granted the permission.")
                } else {
                    print("User did not grant the permission.")
                }
            })
        }
        setData()
    }
    func setData(){
        isDraggingTimeSlider = false
        save = true
        isPlaying = false
        saveBtn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        audioPlayBtn.setImage(#imageLiteral(resourceName: "r_play"), for: .normal)
        
        removeAudioTimer()
        audioplayer?.stop()
        
        let date: Date? = exam.createtime as Date? ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        var stringDate: String? = nil
        if let date = date {
            stringDate = dateFormatter.string(from: date)
        }
        
        countTimeLabel.text = "00:00"
        progressSlider.value = 0
        dateLabel.text = stringDate
        topicLabel.text = exam.qustopic
        questionLabel.text = exam.question
        recordFilePath = exam.voiceAudio
        
        prepreAudioPath()
        audioTimeLabel.text = formatTime(Int(audioDuration))
    }
    func prepreAudioPath() {
        // combine audio file name with document directory
        let Path = "\(NSHomeDirectory())\(recordFilePath)"
        let recordFileURL = URL(fileURLWithPath: Path)
        
        // init audio play (can't init while calling play method if use pause)
        
        audioplayer = try? AVAudioPlayer(contentsOf: recordFileURL)
        guard let audioplayer = audioplayer else {return}
        audioplayer.delegate = self
        audioplayer.numberOfLoops = 0
        audioplayer.currentTime = 0
        audioDuration = audioplayer.duration
        
    }
    
    @IBAction func saveOrNotSavaAction(_ sender: UIButton) {
        if save == true {
            // 按下後變成不存
            saveBtn.setImage(#imageLiteral(resourceName: "dislike"), for: .normal)
            save = false
        } else {
            save = true
            saveBtn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        }
    }
    
    @IBAction func lastButtonPressed(_ sender: UIButton) {
        if index - 1 >= 0 {
            index = index - 1
            exam = examList[index]
            setData()
        }
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if index + 1 < examList.count {
            index = index + 1
            exam = examList[index]
            setData()
        }
    }
    @IBAction func audioPlayButtonPressed(_ sender: UIButton) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        guard let audioplayer = audioplayer else {return}
        if audioplayer.isPlaying {
            sender.setImage(#imageLiteral(resourceName: "r_play"), for: .normal)
            audioplayer.pause()
            removeAudioTimer()
        } else {
            sender.setImage(#imageLiteral(resourceName: "r_playing"), for: .normal)
            audioplayer.prepareToPlay()
            audioplayer.play()
            audioDurationTimer()
        }
    }
    
    func audioDurationTimer() {
        audioDurationCount()
        audioTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.audioDurationCount), userInfo: nil, repeats: true)
    }
    
    @objc func audioDurationCount() {
        guard let audioplayer = audioplayer else {return}
        countTimeLabel.text = formatTime(Int(audioplayer.currentTime))
        
        // 計算進度條比例
        let progressRatio = CGFloat(audioplayer.currentTime / audioplayer.duration)
        
        audioSeconds += 1
        countTimeLabel.text = formatTime(Int(audioplayer.currentTime))
        audioTimeLabel.text = formatTime(Int(audioDuration))
        
        // updating  slider value when finish dragging
        if !isDraggingTimeSlider {
            progressSlider.value = Float(progressRatio)
        }
    }
    
    func removeAudioTimer() {
        audioTimer?.invalidate()
        audioTimer = nil
    }
    
    func formatTime(_ num: Int) -> String {
        let sec: Int = num % 60
        let min: Int = num / 60
        return String(format: "%02d:%02d", min, sec)
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        progressSlider.value = Float(audioDuration)
        countTimeLabel.text = formatTime(Int(audioDuration))
        audioTimeLabel.text = formatTime(Int(audioDuration))
        
        audioPlayBtn.setImage(#imageLiteral(resourceName: "r_play"), for: .normal)
        removeAudioTimer()
        audioplayer?.stop()
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("\(error)")
        }
    }
    @IBAction func startSlider(_ sender: UISlider) {
        guard let audioplayer = audioplayer else {return}
        // if playing pause and stop timer
        if audioplayer.isPlaying {
            isPlaying = true
            audioplayer.pause()
            removeAudioTimer()
            isDraggingTimeSlider = true
        } else {
            // not playing just stop timer
            removeAudioTimer()
            isDraggingTimeSlider = true
        }

    }
    
    @IBAction func endSlide(_ sender: UISlider) {
        // if playing then keep play and start timer
        if isPlaying == true {
            audioplayer?.play()
            audioDurationTimer()
            isDraggingTimeSlider = false
            isPlaying = false
        }
    }
    
    @IBAction func sliderValueChange(_ sender: UIButton) {
        // 拖曳時 countTimeLabel 時間快數轉換
        let progress = progressSlider.value
        let duration = audioplayer?.duration ?? 0
        countTimeLabel.text = formatTime(Int(progress) * Int(duration))
        audioplayer?.currentTime = TimeInterval(progress * Float(duration))
    }
    
    @IBAction func sliderClick(_ sender: UITapGestureRecognizer) {
    }

    func setFont() {
        topicLabel.font = UIFont.regularFont(17)
        questionLabel.font = UIFont.regularFont(25)
        dateLabel.font = UIFont.regularFont(17)
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        setFont()
    }
    
    @objc func navigationBackBtnTap() {
        if save == false {
            deleteVoiceFile(recordFilePath)
            delectFromCoreData()
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            // dont forget to stop all timer and player when leaveing
            audioplayer?.stop()
            audioplayer = nil
            removeAudioTimer()
        }
    }
    func deleteVoiceFile(_ filename: String) {
        let filename = filename.replacingOccurrences(of: "/Documents/", with: "")
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(filename).path
        let success = fileManager.isDeletableFile(atPath: filePath)
        if success {
            do {
                try fileManager.removeItem(atPath: filePath)
                print("刪掉了喔！！！！")
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
        } else {
            print("Could not delete file")
        }
    }
    
    func delectFromCoreData() {
        if ExamDB.delete(recordFilePath) {
            print("ExamDB---刪了----- ")
        }
    }
}
