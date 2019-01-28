//
//  TestVC.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/18.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class TestVC: UIViewController,AVAudioPlayerDelegate,AVAudioRecorderDelegate {
    
    @IBOutlet private weak var qusLabel: UILabel!
    @IBOutlet private weak var hintTextView: UITextView!
    @IBOutlet private weak var topicLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var startRecordBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countLabelTwo: UILabel!
    @IBOutlet weak var playContentView: UIView!
    @IBOutlet weak var playVoiceBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var againBtn: UIButton!
    @IBOutlet weak var countContentView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var setTime: UILabel!
    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var audioProgressBar: UIProgressView!
    
    private var voiceRecorder: AVAudioRecorder?
    private var voicePlayer: AVAudioPlayer?
    
    // 一分鐘倒數
    private var totalSeconds: Int = 0
    private weak var oneMinTimer: Timer?
    // 兩分鐘計時
    private weak var twoMinTimer: Timer?
    private var twoMinSeconds: Int = 0
    // player 倒數
    private weak var audioTimer: Timer?
    private var audioSeconds: Int = 0
   
    private var time: TimeInterval = 0.0
    private var audioDuration: TimeInterval = 0.0
    private var videoFilePath = ""
    private var proValue: Float = 0.0
    private var save = false
    private var started = false
    private var again = false
    private var nevercome = false
    private var play = false
    private var isDraggingTimeSlider = false
    private var isPlaying = false
    
    var quesDic = Question()
    
    @IBAction private func sliderTouchDown(_ sender: Any) {
        // 按下的那剎那 如果正在播放 則暫停播放和時間
        if voicePlayer?.isPlaying ?? false {
            isPlaying = true
            voicePlayer?.pause()
            removeAudioTimer()
            isDraggingTimeSlider = true
        } else {
            // 如果不是在播放 則暫停時間
            removeAudioTimer()
            isDraggingTimeSlider = true
        }
    }
    
    @IBAction private func sliderValueChanged(_ sender: Any) {
        // 更新 label 和 player currentTime
        let value = Double(progressSlider.value)
        let duration:Double = Double(voicePlayer?.duration ?? 0)
        timeLabel.text = "\(formatTime(Int(value * duration)))"
        voicePlayer?.currentTime = value * duration
    }
    
    @IBAction private func sliderTouchUp(inside sender: Any) {
        // 如果剛剛是播放狀態按下 則繼續播放和時間
        if isPlaying == true {
            voicePlayer?.play()
            audioDurationTimer()
            isDraggingTimeSlider = false
            isPlaying = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Test"
        // 題目 label
        qusLabel.numberOfLines = 0
        qusLabel.text = quesDic.question
        let replaceHint = quesDic.Hint.replacingOccurrences(of: "&", with: "\n")
        hintTextView.text = replaceHint
        topicLabel.text = quesDic.qustopic
        automaticallyAdjustsScrollViewInsets = false
        hintTextView.layoutManager.allowsNonContiguousLayout = false
        
        playContentView.isHidden = true
        started = false
        save = false
        nevercome = true
        play = false
        twoMinSeconds = 1
        isDraggingTimeSlider = false
        audioProgressBar.progress = 0
        audioProgressBar.isHidden = true
        countContentView.isHidden = true
        progressSlider.isHidden = true
        isPlaying = false
        
        fontFamily()
        
        let image = #imageLiteral(resourceName: "back-1")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(TestVC.navigationBackBtnTap))
        navigationItem.leftBarButtonItem = backButton
        
        // requestRecordPermission
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
        
        // 一分鐘倒數的timer
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { timer in
            self.oneMinTimerCount()
        })
    }
    
    // MARK: - one minute count method
    func oneMinTimerCount() {
        totalSeconds = 60
        oneMinTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TestVC.tick), userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        
        totalSeconds -= 1
        countLabel.text = "\(totalSeconds / 10)"
        countLabelTwo.text = "\(totalSeconds % 10)"
        
        if totalSeconds == 0 {
            oneMinTimer?.invalidate()
            prepareRecording()
            voiceRecorder?.record(forDuration: 135)
            started = true
            startRecordBtn.setImage(UIImage(named: "stopRecord"), for: .normal)
            contentView.isHidden = true
            twoMinuteTimer()
        }
    }
    
    // MARK: - two minute count method
    func twoMinuteTimer() {
        twoMinSeconds = 1
        audioProgressBar.progress = 0.0
        proValue = 0
        twoMinTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TestVC.countTime), userInfo: nil, repeats: true)
        
    }
    
    @objc func countTime() {
        twoMinSeconds += 1
        
        lightImageViewSetting()
        timeLabel.text = formatTime(twoMinSeconds)
        setTime.text = formatTime(135)
        
        // 1 / 135 = 0.00740 一秒跑這樣
        proValue += 0.00740
        audioProgressBar.progress = proValue
        
        // 兩分鐘到了自動停止
        if twoMinSeconds == 135 {
            twoMinTimer?.invalidate()
            // 顯示為02:00/02:00
            timeLabel.text = formatTime(135)
            setTime.text = formatTime(135)
            playContentView.isHidden = false
            startRecordBtn.isHidden = true
            audioProgressBar.progress = 1
            // 錄音結束後準備檔案給 player 播放
            prepreAudioPath()
        }
    }
    
    func formatTime(_ num: Int) -> String {
        let sec: Int = num % 60
        let min: Int = num / 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    func lightImageViewSetting() {
        // 給燈提示 一分鐘橘燈 一分半綠燈 兩分鐘紅燈
        if twoMinSeconds == 60 {
            lightImageView.image = UIImage(named: "orange")
        } else if twoMinSeconds == 65 {
            lightImageView.isHidden = true
        } else if twoMinSeconds == 90 {
            lightImageView.isHidden = false
            lightImageView.image = UIImage(named: "green")
        } else if twoMinSeconds == 95 {
            lightImageView.isHidden = true
        } else if twoMinSeconds == 120 {
            lightImageView.isHidden = false
            lightImageView.image = UIImage(named: "red")
        } else if twoMinSeconds == 125 {
            lightImageView.isHidden = true
        }
    }
    
    // MARK: - record Voice Button Pressed method
    @IBAction func recordVoiceButtonPressed(_ sender: UIButton) {
        if voiceRecorder?.isRecording != nil {
            // 按下後停止錄音
            sender.setImage(UIImage(named: "startRecord"), for: .normal)
            voiceRecorder?.stop()
            voiceRecorder = nil
            // 不能再度錄音
            playContentView.isHidden = false
            startRecordBtn.isHidden = true
            // 錄音結束後準備檔案給 player 播放
            prepreAudioPath()
            // 停止計時
            twoMinTimer?.invalidate()
        } else {
            started = true
            voiceRecorder?.delegate = self
            sender.setImage(UIImage(named: "stopRecord"), for: .normal)
            contentView.isHidden = true
            // 停止一分鐘倒數計時
            oneMinTimer?.invalidate()
            countLabel.text = "\(6)"
            countLabelTwo.text = "\(0)"
            countContentView.isHidden = false
            audioProgressBar.isHidden = false
            // 開始兩分鐘計時
            twoMinuteTimer()
            prepareRecording()
            // 開始為期兩分鐘錄音
            voiceRecorder?.record(forDuration: 135)
        }
    }
    
    // MARK: - if user want to record again
    @IBAction func againButtonPressed(_ sender: UIButton) {
        sender.setImage(UIImage(named: "again"), for: .normal)
        let recordFilePath = String(format: "%frecord.caf", time)
        // clean new time for file name
        time = 0
        // 如果 again 之前沒有存檔 則捨棄剛剛的音檔
        if save == false {
            deleteVoiceFile(recordFilePath)
        }
        
        nevercome = false
        playContentView.isHidden = true
        contentView.isHidden = false
        startRecordBtn.isHidden = false
        progressSlider.isHidden = true
        countContentView.isHidden = true
        audioProgressBar.isHidden = true
        started = false
        oneMinTimerCount()
        saveBtn.setImage(UIImage(named: "noSave"), for: .normal)
        save = false
        audioProgressBar.progress = 0.0
        timeLabel.text = formatTime(0)
    }
    
    // MARK: - play Voice Button Pressed method
    @IBAction func playVoiceButtonPressed(_ sender: UIButton) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        
        audioProgressBar.isHidden = true
        progressSlider.isHidden = false
        
        if voicePlayer?.isPlaying != nil {
            sender.setImage(UIImage(named: "play"), for: .normal)
            voicePlayer?.pause()
            removeAudioTimer()
        } else {
            sender.setImage(UIImage(named: "stopPlay"), for: .normal)
            voicePlayer?.prepareToPlay()
            voicePlayer?.play()
            audioDurationTimer()
        }
    }
    
    func prepreAudioPath() {
        let recordFilePath = String(format: "%@/Documents/%frecord.caf", NSHomeDirectory(), Int(time))
        let recordFileURL = URL(fileURLWithPath: recordFilePath)
        voicePlayer = try? AVAudioPlayer(contentsOf: recordFileURL)
        voicePlayer?.delegate = self
        voicePlayer?.numberOfLoops = 0
        audioDuration = voicePlayer?.duration ?? 0.0
    }
    
    func audioDurationTimer() {
        audioDurationCount()
        audioSeconds = 1
        audioTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TestVC.audioDurationCount), userInfo: nil, repeats: true)
        if let audioTimer = audioTimer {
            RunLoop.main.add(audioTimer, forMode: .common)
        }
        
    }
    
    @objc func audioDurationCount() {
        let progressRatio = CGFloat((voicePlayer?.currentTime ?? 0.0) / (voicePlayer?.duration ?? 0.0))
        
        audioSeconds += 1
        timeLabel.text = formatTime(Int(voicePlayer?.currentTime ?? 0))
        
        setTime.text = formatTime(Int(audioDuration))
        
        if !isDraggingTimeSlider {
            progressSlider.value = Float(progressRatio)
        }
    }
    
    func removeAudioTimer() {
        audioTimer?.invalidate()
        audioTimer = nil
    }
    
    // MARK: - save test data to core data method
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let recordFilePath = String(format: "/Documents/%drecord.caf", Int(time))
        
        if save == false {
            // 如果還沒存 要存
            sender.setImage(UIImage(named: "save"), for: .normal)
            save = true
            again = false
            var examList = ExamList()
            examList.createtime = NSDate()
            examList.qustopic = quesDic.qustopic
            examList.question = quesDic.question
            examList.voiceAudio = recordFilePath
            if ExamDB.insert(examList) {
                print("存了！！！！！")
            }
        } else {
            // 如果又反悔剛剛的存檔 則刪除
            sender.setImage(UIImage(named: "noSave"), for: .normal)
            if ExamDB.delete(recordFilePath) {
                print("刪了也存了！！！！！")
            }
            save = false
            again = true
        }
    }
    
    // MARK: - finish record or play method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        progressSlider.value = Float(voicePlayer?.duration ?? 0)
        timeLabel.text = formatTime(Int(audioDuration))
        setTime.text = formatTime(Int(audioDuration))
        playVoiceBtn.setImage(UIImage(named: "play"), for: .normal)
        removeAudioTimer()
        voicePlayer?.stop()
        
    }
    
    // MARK: - prepareRecording file path method
    func prepareRecording() {
        let settings = [
            AVFormatIDKey: NSNumber(value: Int32(kAudioFormatAppleIMA4)),
            AVSampleRateKey: NSNumber(value: 22050.0),
            AVNumberOfChannelsKey: NSNumber(value: 1),
            AVLinearPCMBitDepthKey: NSNumber(value: 16),
            AVLinearPCMIsBigEndianKey: NSNumber(value: false),
            AVLinearPCMIsFloatKey: NSNumber(value: false)
        ]
        
        // Decide Record File Path
        let date = Date()
        time = date.timeIntervalSince1970
        
        let recordFilePath = String(format: "%@/Documents/%drecord.caf", NSHomeDirectory(), Int(time))
        let recordFileURL = URL(fileURLWithPath: recordFilePath)
        print("Record File Path: \(recordFilePath)")
        videoFilePath = recordFilePath
        
        voiceRecorder = try? AVAudioRecorder(url: recordFileURL, settings: settings)
        
        voiceRecorder?.prepareToRecord()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
    }
    
    // MARK: - navigation Back Btn Tap
    @objc func navigationBackBtnTap() {
        // 確保使用者不是忘了按存檔，可能會添加設定按鈕讓他選擇要不要跳提醒
        if started == true && save == false && again == true {
            alertSetMessage("", settitle: "leave or save")
        }
        if nevercome == true && started == true && save == false {
            alertSetMessage("", settitle: "leave or save")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func deleteVoiceFile(_ filename: String?) {
        // 離開時不想存剛剛的音檔 則刪除
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(filename!).path
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
    
    func alertSetMessage(_ message: String?, settitle title: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: { action in
            let recordFilePath = String(format: "/Documents/%drecord.caf", Int(self.time))
            var examList = ExamList()
            examList.createtime = NSDate()
            examList.qustopic = self.quesDic.qustopic
            examList.question = self.quesDic.question
            examList.voiceAudio = recordFilePath
            if ExamDB.insert(examList) {
                print("存了！！！！！")
            }
        })
        
        let cancel = UIAlertAction(title: "Leave", style: .cancel, handler: { action in
            let recordFilePath = String(format: "%drecord.caf", Int(self.time))
            self.deleteVoiceFile(recordFilePath)
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    // MARK: - Disappear and shut down all timer
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            // 離開前先關閉所有timer 和 audio player reocrder
            timerInvalidate()
            voicePlayer?.stop()
            voicePlayer = nil
            voiceRecorder?.stop()
            voiceRecorder = nil
            print("我走了--------------------------")
        }
    }
    
    func timerInvalidate() {
        
        oneMinTimer?.invalidate()
        oneMinTimer = nil
        twoMinTimer?.invalidate()
        twoMinTimer = nil
        audioTimer?.invalidate()
        audioTimer = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Test"
        tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fontFamily() {
        topicLabel.font = UIFont.lightFont(15)
        qusLabel.font = UIFont.regularFont(22)
        hintTextView.font = UIFont.lightFont(17)
    }
}
