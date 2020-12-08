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
    @IBOutlet weak var expireDate: UITextField!
    @IBOutlet weak var content: UITextView!
    
    
    var categoryButton = [UIButton]()
    var datePicker = UIDatePicker()
    var notiCenter = NotificationCenter.default
    var keyboardShown:Bool = false // 키보드 상태 확인
    var originY:CGFloat? // 오브젝트의 기본 위치
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryButton = [cafe,restaurant,shopping,convenienceStore]
        showDatePicker()
        price.delegate = self
    }

    /// 키보드가 텍스트 입력창을 가리지 않도록 함
    // 키보드가 나타나고 사라질때 노티피케이션
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(note: NSNotification) {
        if self.content.isFirstResponder {
            if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if keyboardSize.height == 0.0 || keyboardShown == true {
                    return
                }

                UIView.animate(withDuration: 0.33, animations: { () -> Void in
                    if self.originY == nil { self.originY = self.view.frame.origin.y }
                    self.view.frame.origin.y = self.originY! - keyboardSize.height
                }, completion: {_ in
                    self.keyboardShown = true
                })
            }
        }
    }

    @objc func keyboardWillHide(note: NSNotification) {
        if self.content.isFirstResponder {
            if let _ = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if keyboardShown == false {
                    return
                }

                UIView.animate(withDuration: 0.33, animations: { () -> Void in
                    guard let originY = self.originY else { return }
                    self.view.frame.origin.y = originY
                }, completion: {_ in
                    self.keyboardShown = false
                })
            }
        }
    }
    
    // superview 터치 시 키보드 내림
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
    
    /// 숫자가 입력되면 셋째 자리 수마다 콤마 삽입
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
            } else { // 숫자 입력이 아니면
                if string == "" {
                    let lastIndex = beforeFormatting.index(beforeFormatting.endIndex, offsetBy: -1)
                    beforeFormatting = String(beforeFormatting[..<lastIndex])
                    if let formattedNumber = numberFormat.number(from: beforeFormatting), let formattedString = numberFormat.string(from: formattedNumber) {
                        textField.text = formattedString
                        return false
                    }
                }
            }
        }
        return true
    }
    
    ///데이트피커 설정
   func showDatePicker() {
        expireDate.inputView = datePicker
        
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
        expireDate.inputAccessoryView = toolbar
    }
    
    @objc func datePickerDone() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일 hh:mm a"
        let selectDate = dateFormat.string(from: datePicker.date)
       
        expireDate.text = selectDate
        self.view.endEditing(true)
    }
    
    /// 내용 입력 창 
    // 참고 : https://zeddios.tistory.com/406
    // NSTextAttachment
    func couponContent() {
        
    }
}
