//
//  AddViewController.swift
//  Coupon
//
//  Created by 김지나 on 2020/09/26.
//  Copyright © 2020 김지나. All rights reserved.
//





// TODO: -----------------------
/*
 xcode12에서 ios12 이하 버전 사용하기
 검색어 : xcode12 ios12
 -------------------------------
 */


import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cafe: UIButton!
    @IBOutlet weak var restaurant: UIButton!
    @IBOutlet weak var shopping: UIButton!
    @IBOutlet weak var convenienceStore: UIButton!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var fromDate: UITextField!
    @IBOutlet weak var toDate: UITextField!
    @IBOutlet weak var content: UITextView!
    
    var categoryButton = [UIButton]()
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryButton = [cafe,restaurant,shopping,convenienceStore]
        showDatePicker()
        price.delegate = self
    }

    // 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //분류 선택
    @IBAction func selectCategory(_ sender: UIButton) {
        for button in categoryButton {
            if sender.tag == button.tag {
                button.tintColor = .systemYellow
            } else {
                button.tintColor = .lightGray
            }
        }
    }
    
    // 숫자가 입력되면 셋째 자리 수마다 콤마 삽입
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.locale = Locale.current // 지역에 따른 .decimal의 차이를 반영 (디바이스에 설정된 지역으로 값 설정)
        numberFormat.maximumFractionDigits = 0 // 소숫점을 허용하지 않을 때 0 설정
        
        // numberFormat.groupingSeparator = .decimal의 구분점을 의미
        // with: "" = 이 구분점을 ""으로 대체한다는 것으로 ','를 제거한다는 의미
        if let removeAllSeparator = textField.text?.replacingOccurrences(of: numberFormat.groupingSeparator, with: "") {
            var beforeFormatting = removeAllSeparator + string // ','가 제거된 문자열과 새로 입력된 문자열을 합침
            if numberFormat.number(from: string) != nil {
                if let formattedNumber = numberFormat.number(from: beforeFormatting), let formatString = numberFormat.string(from: formattedNumber) {
                    textField.text = formatString
                    return false
                }
            } else {
                if string == "" {
                    let lastIndex = beforeFormatting.index(beforeFormatting.endIndex, offsetBy: -1)
                    beforeFormatting = String(beforeFormatting[..<lastIndex])
                    if let formattedNumber = numberFormat.number(from: beforeFormatting), let formattedString = numberFormat.string(from: formattedNumber) {
                        textField.text = formattedString
                        return false
                    }
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    //데이트피커 설정
   func showDatePicker() {
        fromDate.inputView = datePicker
        toDate.inputView = datePicker
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.translatesAutoresizingMaskIntoConstraints = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(datePickerDone))
        toolbar.setItems([space,done], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        fromDate.inputAccessoryView = toolbar
        toDate.inputAccessoryView = toolbar
    }
    
    @IBAction func selectDateTextField(_ sender: UITextField) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일 hh:mm a"
        let selectDate = dateFormat.string(from: datePicker.date)
       
        if sender.tag == 0 {
            fromDate.text = selectDate
        } else {
            toDate.text = selectDate
        }
    }
    
    @objc func datePickerDone() {
        self.view.endEditing(true)
    }
    
    
    // 참고 : https://zeddios.tistory.com/406
    // NSTextAttachment
    func couponContent() {
        
    }
}
