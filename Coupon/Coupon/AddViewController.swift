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
import SQLite3

class AddViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cafe: UIButton!
    @IBOutlet weak var restaurant: UIButton!
    @IBOutlet weak var shopping: UIButton!
    @IBOutlet weak var convenienceStore: UIButton!
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var expireDate: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var categoryButton = [UIButton]()
    var keyboardShown:Bool = false // 키보드 상태 확인
    var originY:CGFloat? // 오브젝트의 기본 위치
    var category = ""
    let imagePickerController = UIImagePickerController()
    var contentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryButton = [cafe,restaurant,shopping,convenienceStore]
        price.delegate = self
        content.layer.borderColor = #colorLiteral(red: 0.7999381423, green: 0.8000349402, blue: 0.7999051213, alpha: 1)
        content.layer.borderWidth = 1.0
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
                category = (button.currentTitle!).components(separatedBy: [" "]).joined()
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
    @IBAction func showDatePic(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        screenView.isHidden = false
        datePickerView.isHidden = false
    }

    
    @IBAction func datePickerDone() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        let selectDate = dateFormat.string(from: datePicker.date)
       
        expireDate.text = selectDate
        
        screenView.isHidden = true
        datePickerView.isHidden = true
    }
    
    /// 내용 입력 창 
    @IBAction func addPhoto(_ sender: UIButton) {
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 이미지 방향이 정방향이 아니면 정방향으로 돌려줌
    func imageRotate(image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normal = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normal
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] {
            let selectImage = image as? UIImage
            photo.image = resizeImage(image: selectImage ?? UIImage(), size: photo.bounds.width)
            contentImage = imageRotate(image: selectImage!)
        }
        // 이미지뷰에 사진이 선택되어져 있을 때만 탭제스쳐 액션 삽입
        let photoGesture = UITapGestureRecognizer(target: self, action: #selector(photoZoom))
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(photoGesture)
        
        dismiss(animated: true, completion: nil)
    }
    
    // 선택한 이미지를 이미지뷰 사이즈에 맞게 조절
    func resizeImage(image: UIImage, size: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        image.draw(in: CGRect(x: 0, y: 0, width: size, height: size))
        let newimg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimg!
    }
    
    // 선택 이미지 삭제
    @IBAction func clearPhoto(_ sender: UIButton) {
        photo.image = UIImage(systemName: "camera.fill")
        photo.isUserInteractionEnabled = false
        contentImage = nil
    }
    
    // 선택한 이미지를 크게 볼 수 있도록 줌컨트롤러로 연결
    @objc func photoZoom() {
        let photoZoomView = self.storyboard?.instantiateViewController(withIdentifier: "photoZoom") as! PhotoZoomViewController
        photoZoomView.image = contentImage
        self.navigationController?.pushViewController(photoZoomView, animated: true)
    }
    
    // 쿠폰값 저장
    @IBAction func saveData(_ sender: Any) {
        if category == "" {
            alert(nilCheck: "category")
        } else if shopName.text == "" {
            alert(nilCheck: "shopName")
        } else if expireDate.text == "" {
            alert(nilCheck: "expire")
        } else {
            let format = DateFormatter()
            format.locale = Locale(identifier: "ko_KR")
            format.timeZone = TimeZone(abbreviation: "KST")
            format.dateFormat = "yyyy년 MM월 dd일"
            let expire = format.date(from: expireDate.text!)
            
            let db = Database.shared
            var id = db.getID()
            
            if id == 0 {
                id = 1
            } else {
                id += 1
            }
            
            db.insert(id: id, category: category, shop: shopName.text!, price: price.text ?? "0", expireDate: expire!, content: content.text, contentPhoto: contentImage ?? UIImage())
            
            self.navigationController?.popViewController(animated: true)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "save"), object: nil)
        }
    }
    
    // 필수 항목 미기재시 에러메세지 알럿
    func alert(nilCheck: String) {
        var message = ""
        
        switch nilCheck {
        case "shopName":
            message = "상호를 입력해주세요"
        case "category":
            message = "분류를 선택해주세요"
        case "expire":
            message = "쿠폰의 만료일을 선택하여 주세요"
        default:
            message = "필수 항목이 입력되지 않았습니다."
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

