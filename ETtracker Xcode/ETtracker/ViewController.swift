//
//  ViewController.swift
//  ETtracker
//
//  Created by Sean Hall on 11/11/20.
//

import UIKit
import CoreMotion
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    public var actions = ["jump","run","3","4","5"]
    
    public var xmotionData = ["X"]
    public var ymotionData = ["Y"]
    public var zmotionData = ["Z"]
    public var allMotionDate = ["T,X,Y,Z"]
    public var i = 1
    
    @IBAction func tremorObservedPressed(_ sender: UIButton) {
        //allMotionDate.append("A mild tremor was observed")
    }
    
    @IBAction func mediumTremorObserved(_ sender: UIButton) {
        //allMotionDate.append("A medium tremor was observed")
    }
    
    @IBAction func severTremorObserved(_ sender: UIButton) {
        //allMotionDate.append("A  severe tremor was observed")
    }
    public let motion = CMMotionManager()
    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var actionTask: UILabel!
    @IBAction func saveButtonPressed(_ sender: Any) {
        allMotionDate.removeAll()
        i = 1
        trackStatus.text = ""
        actionTask.text = actions[i]
        allMotionDate.append("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
    @IBAction func startTracking(_ sender: Any) {
       startAccelerometers()
        trackStatus.text = "Tracking has begun"
        trackStatus.backgroundColor = .green
    }
    
    @IBAction func pullUpMail(_ sender: Any) {
        shareData()
    }
    @IBOutlet weak var accelReport: UILabel!
    @IBOutlet weak var trackStatus: UILabel!
    @IBAction func stopTracking(_ sender: Any) {
        
        stopUpdates()
        //stops the accelerometer
        trackStatus.text = "Tracking has Stopped"
        trackStatus.backgroundColor = .red
        //update the task label
        actionTask.text = actions[i]
        //append the accel data to our array
        xmotionData.append(" \(actions[i])")
        ymotionData.append(" \(actions[i])")
        zmotionData.append(" \(actions[i])")
        //allMotionDate.append("")
        //could seperate data set into different tasks
       
        i += 1
        if i > 4 {
            i = 1
            actionTask.text = ""
            
        }
    }
    func stopUpdates() {
        
        
        if self.motion.isAccelerometerAvailable && self.motion.isGyroAvailable {
            self.motion.stopAccelerometerUpdates()
            self.motion.stopGyroUpdates()
            
            
        }
            else { return }

        
        
    }
    func shareData() {
        //segue to new preview page that plots and graphs the data with task title breaking up the data, then add share button to email or air drop 
        print("your data has been shared")
        let dataToMail = allMotionDate
        
        prepareMail(data: dataToMail)
        
        
    }
    func organizeGyro(){
        
    }
    func organizeAccel(){
        
    }
 
    func prepareMail(data:[String]) {
        // Compose the mail
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["hangtech@icloud.com"])
        mailComposer.setSubject("ETtrackerAccelData")
        mailComposer.setMessageBody("Accelerometer data from clinic ", isHTML: false)

        // Name data files (accelerometer + label)
        let fileName = "patientacceldata"
        

        if let dataToAttach = data.map({String($0)}).joined(separator: "\n").data(using: .utf8)
        {
            mailComposer.addAttachmentData(dataToAttach, mimeType: "text/csv", fileName: "\(fileName)")
            self.present(mailComposer, animated: true, completion: nil)
        }
        

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
   

func startAccelerometers() {
    
      // Make sure the accelerometer hardware is available.
    if self.motion.isAccelerometerAvailable && self.motion.isGyroAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 20.0 // 20 Hz
            self.motion.startAccelerometerUpdates()
        self.motion.gyroUpdateInterval = 1.0 / 20.0
        self.motion.startGyroUpdates()

         // Configure a timer to fetch the data.
         let timer = Timer(fire: Date(), interval: (1.0/20.0),
               repeats: true, block: { (timer) in
            // Get the accelerometer data.
            if let data = self.motion.accelerometerData {
               let x = data.acceleration.x
               let y = data.acceleration.y
               let z = data.acceleration.z
                //let date = Date()
                //let tStamp = date.timeIntervalSinceNow * -1
                
                //or
                
                //
            
                let currentDateTime = Date()
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .none
                let tStamp = formatter.string(from: currentDateTime)
                //var timeStamp = 0.05
                //print(timer.)
               
        
                if let gyroData = self.motion.gyroData {
                    
                    let gx = gyroData.rotationRate
                    
                    self.allMotionDate.append("\(tStamp), \(gx.x), \(gx.y), \(gx.z)")
                }
               //self.xAccel.text = "your x acceleration is \(x)"
               //self.xAccel.text = "your y acceleration is \(y)"
              // self.xAccel.text = "your z acceleration is \(z)"
               if (abs(x) <= 0.009 && abs(y) <= 0.009) {
                  //we could add logic to stop looking at data or add a note to the array
               }
               else {
                   //once we can classify each type of tremor here is where we will be
               }
               //print("x \(x), y \(y), z \(z)")
                self.xmotionData.append("\(x)")
                self.ymotionData.append("\(y)")
                self.zmotionData.append("\(z)")
                self.allMotionDate.append("\(tStamp),\(x),\(y),\(z)")
                
                
                //self.accelReport.text = "x \(x), y \(y), z \(z)"

                
                           
                       
               
                
             }
          })
            

          // Add the timer to the current run loop.
        RunLoop.current.add(timer, forMode: .default)
       }
    
}
                  
         

}
