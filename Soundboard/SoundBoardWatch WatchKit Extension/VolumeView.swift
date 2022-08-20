//
//  VolumeView.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 24.04.22.
//

import WatchKit
import Foundation
import AVFoundation
//import MediaPlayer


class VolumeInterfaceController: WKInterfaceController {
    @IBOutlet weak var volumeView: WKInterfaceVolumeControl!
    
    @IBOutlet weak var yearPicker: WKInterfacePicker!
    @IBOutlet weak var dayPicker: WKInterfacePicker!
    @IBOutlet weak var monthPicker: WKInterfacePicker!
    @IBOutlet weak var dateTill: WKInterfaceLabel!
    
    
    var selectedMonth : Int = 0
    var selectedYear : Int = 0
    var selectedDay : Int = 0
    
    var settedMonth : Int = 0
    var settedYear : Int = 0
    var settedDay : Int = 0
    
    
    static let maximumPlusYears = 10
    
    let months: [(String, Int)] = NSDate.getAllTreeDigitsMonthRepresentationForCurrentLocale()
    
    let years: [Int] = {
            let (_,_,year) = NSDate().dayMonthYear
            let maximum = year + maximumPlusYears
            var _years = [Int]()
            for _year in year...maximum {
                let cuttedYear = _year-2000
                _years.append(cuttedYear)
            }
            return _years
        }()
    
    
    var days: [Int] {
        get {
            let numberOfDays = NSDate.daysCountInMonth(year: selectedYear, month: selectedMonth)
            var _days = [Int]()
            for _day in  1...numberOfDays{
                _days.append(_day)
            }
            return _days
        }
    }
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        volumeView.focus()
        
        let  (day, month, year) = NSDate().dayMonthYear
        
        selectedMonth = month - 1
        selectedYear = year
        selectedDay = day - 1
        
        settedDay = UserDefaults.standard.integer(forKey: "settedDay")
        settedMonth = UserDefaults.standard.integer(forKey: "settedMonth")
        settedYear = UserDefaults.standard.integer(forKey: "settedYear")
        
    }
    
    override func willDisappear() {
        volumeView.resignFocus()
    }
    
    override func willActivate() {
        super.willActivate()
        
        settedDay = UserDefaults.standard.integer(forKey: "settedDay")
        settedMonth = UserDefaults.standard.integer(forKey: "settedMonth")
        settedYear = UserDefaults.standard.integer(forKey: "settedYear")
        
        let date = UserDefaults.standard.object(forKey: "selectedDate") as! Date
        let days = getDaysBetweenDates(from: Date(), to: date)
        settedDaysTill = days
        UserDefaults.standard.set(settedDaysTill, forKey: "settedDaysTill")

        dateTill.setText("\(settedDaysTill) Days till \(settedDay+1).\(settedMonth).\(settedYear)")
        
        setMonthsPicker()
        setDaysPicker()
        setYearsPicker()
        
    }
    
    //MARK: Set Pickers
    func setDaysPicker() {
        let pickerItems : [WKPickerItem] = days.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.description
            pickerItem.caption = $0.description
            return pickerItem
        }
        dayPicker.setItems(pickerItems)
        if pickerItems.count - 1 < settedDay {
            selectedDay = pickerItems.count - 1
        }
        dayPicker.setSelectedItemIndex(settedDay)
    }
    
    func setMonthsPicker() {
        let pickerItems: [WKPickerItem] = months.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.0
            pickerItem.caption = $0.1.description
            return pickerItem
        }
        monthPicker.setItems(pickerItems)
        monthPicker.setSelectedItemIndex(settedMonth-1)
    }
    
    func setYearsPicker(){
        let pickerItems: [WKPickerItem] = years.map {
            let pickerItem = WKPickerItem()
            pickerItem.title = $0.description
            pickerItem.caption = $0.description
            return pickerItem
        }
        yearPicker.setItems(pickerItems)
        //let (_,_,year) = NSDate().dayMonthYear
        //let index = years.count - (year + selectedYear-2000) - 1
        guard let index = years.firstIndex(of: settedYear-2000) else{
            print("index error: settedyear: \(settedYear)")
            yearPicker.setSelectedItemIndex(0)
            return
        }
        yearPicker.setSelectedItemIndex(index)
    }
    

    
    
    
    //MARK: Set Date Action
    @IBAction func setDateAction() {
        let selectedDate = NSDate.buildDateFor(year: selectedYear, month: selectedMonth , day: selectedDay + 2)
//        let calendar = Calendar.current
//        let date1 = calendar.startOfDay(for: Date())
//        let date2 = calendar.startOfDay(for: selectedDate as Date)
//
//        let components = calendar.dateComponents([.day], from: date1, to: date2)
//        let days = components.day! - 1
        let days = getDaysBetweenDates(from: Date(), to: selectedDate as Date)
        
        settedMonth = selectedMonth
        settedDay = selectedDay
        settedYear = selectedYear
        settedDaysTill = days
        
        print(selectedDate)
        UserDefaults.standard.set(settedDaysTill, forKey: "settedDaysTill")
        UserDefaults.standard.set(settedDay, forKey: "settedDay")
        UserDefaults.standard.set(settedMonth, forKey: "settedMonth")
        UserDefaults.standard.set(settedYear, forKey: "settedYear")
        
        UserDefaults.standard.set(selectedDate, forKey: "selectedDate")
        
        dateTill.setText("\(settedDaysTill) Days till \(settedDay+1).\(settedMonth).\(settedYear)")

    }
    
    //MARK: Picker Actions
    @IBAction func dayPicker(_ value: Int) {
        selectedDay = value
    }
    
    @IBAction func monthPicker(_ value: Int) {
        selectedMonth = Int(months[value].1)
        setDaysPicker()
    }
    @IBAction func yearPicker(_ value: Int) {
        selectedYear = years[value] + 2000
        if selectedMonth == 2 {
            setDaysPicker()
        }
    }
    
}//eoc


//MARK: Date Extension
extension NSDate {
    
    var dayMonthYear: (Int, Int, Int) {
        let components = NSCalendar.current.dateComponents([.day, .month, .year], from: self as Date)
        return (components.day!, components.month!, components.year!)
    }
    
    static func buildDateFor(year: Int, month: Int, day: Int) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        let gregorian = NSCalendar(identifier:NSCalendar.Identifier.gregorian)
        let date = gregorian!.date(from: c as DateComponents)
        return date! as NSDate
    }
    
    static func daysCountInMonth(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
//    func dateRepresentation()-> String{
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MMM-YYYY"
//        formatter.timeZone = NSTimeZone.system
//        return formatter.string(from: self as Date)
//    }
    
    static func getAllTreeDigitsMonthRepresentationForCurrentLocale() -> [(String, Int)]{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.timeZone = NSTimeZone.system
    
        var months: [(String, Int)] = []
        var cursorDate: NSDate
        for i in 1..<13 {
            cursorDate = NSDate.buildDateFor(year: 2015, month: i, day: 1)
            months.append((formatter.string(from: cursorDate as Date), i ))
        }
        return months
    }
    
    
    

}


