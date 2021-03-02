# Coupon

## 쿠폰 추가 화면-------

### 분류

기능 : 라디오 버튼처럼 하나의 버튼만 선택되도록 구현

문제 : 선택한 버튼과 선택되지 않은 버튼을 구분해야 선택한 버튼에만 효과를 줄 수 있다. 각 버튼을 아울렛 연결 하지 않고 구현하는 방법?

해결 : 이렇게 저렇게 생각해봤지만 결국 아울렛을 연결했다.... 차차 더 공부해서 수정해봐야겠다. 

```swift
@IBOutlet weak var cafeButton: UIButton!
@IBOutlet weak var restaurantButton: UIButton!    @IBOutlet weak var shoppingButton: UIButton!
@IBOutlet weak var convenienceStoreButton: UIButton!
    
var categoryButton = [UIButton]()

categoryButton = [cafeButton,restaurantButton,shoppingButton,convenienceStoreButton]

@IBAction func selectCategory(_ sender: UIButton) {
    for button in categoryButton {
        if sender.tag == button.tag {
            button.tintColor = .systemYellow
        } else {
            button.tintColor = .lightGray
        }
    }
}
```

### 금액

금액 입력 시 셋째 자리 이상 입력 되면 바로바로 콤마로 셋째 자리 수 구분되어 입력 되도록 함

UITextFieldDelegate를 채택하고 shouldChangeCharactersIn 메소드를 사용하여 금액에 입력되는 숫자를 NumberFormatter를 이용하여 변환 한다.

```swift
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
```

### 유효기간

텍스트필드 대신 데이트피커가 보여지고

데이트피커에 툴바를 이용해 done 버튼을 추가하여 날짜 선택 완료 후 키보드가 내려가도록 한다.

(touchesBegan과 동일한 기능이지만 완료버튼이 있으므로 선택을 완료했음을 인지하도록 함)

선택한 날짜는 DateFormatter를 이용해서 보기 좋게 정리하고 텍스트 필드에 삽입한다.

```swift
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
```

데이트피커가 한글로 나오도록 설정

```swift
infoPlist - Localization native development region - Korea
```

### 키보드 설정

내용을 입력 받으려면 키보드가 필요한데 키보드가 화면에 올라오면서 내용 텍스트필드를 가려버린다.따라서 내용을 입력할 때 화면이 전체적으로 키보드 높이 만큼 올라가게 되면 입력 창을 가리지 않게 된다.

그러나 키보드 높이보다 위에 위치한 다른 텍스트필드들에게는 화면 높이 조정이 불필요 하므로 내용 텍스트필드에만 화면의 높이를 조정하면 되었다.

notification에 observer를 추가해주고 selector objc 함수에서 내용이 선택이 되었을 경우에만 키보드 높이가 조정 되도록 했다.

```swift
if self.content.isFirstResponder { ...... }
```

### 저장

입력된 쿠폰의 정보들을 저장하기 위해 userDefault, coreData, SQLite 중 어떤 방식을 이용해야 하는지 고민했다. 단순히 쿠폰의 정보를 저장하고 원하는 때에 원하는 정보만 보여주기만 하면 되므로 SQLite의 사용을 결정하였다.

### ERROR

다른 피시에서 프로젝트를 실행하니 갑자기 레이아웃 에러가 발생했다
"Unable to simultaneously stisfy constraints. ... Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger."
데이트피커에 설정한 툴바의 레이아웃 문제로 툴바의 폭을 임의로 뒀을때 화면 너비로 설정하게 되는거 같은데 이게 에러를 발생시킨다.
그래서 그냥 초기화 시켰던 툴바를 사이즈를 아예 정해주게 되면 에러가 발생하지 않는다.

```swift
let toolbar = UIToolbar() // 기존 error 발생
let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: datePicker.layer.frame,width, height: CGFloat(40)))) // 변경 error 사라짐
```

## 메인화면-------

### 메인으로 보여줄 쿠폰정보

유효기간이 임박한 쿠폰 정보를 보여준다.

기존에 저장되어 있는 쿠폰이 없으면 등록되어 있는 쿠폰이 없음을 알린다. 하나가 추가되면 추가된 쿠폰의 정보를 보여준다. 새롭게 하나가 더 추가되어 쿠폰 개수가 2개 이상이 된다면, 기존에 보여주고 있던 쿠폰의 유효기간과 비교하여 더 빠른 날짜의 쿠폰을 보여주도록 설정한다.

데이터베이스에 새로운 쿠폰이 추가되고 나면 새로운 쿠폰과 기존 임박 쿠폰과 비교하여 버튼에 새롭게 업데이트 해야 하는데 네비게이션에 push와 pop으로 화면 전환을 키켰더니 뷰가 새로 로드 되지 않는다...

------------------------

보여주어야 할 쿠폰이 만약 여러개 라면, 버튼으로는 여러개의 쿠폰을 보여 줄 수 없으므로 scrollView와 pageControl을 사용하도록 변경하였다.

--------------

AddViewController의 save버튼이 눌리면 MainViewController를 다운캐스팅 해와서 MainViewController에서 쿠폰을 비교 처리하는 메소드를 호출해본다.

호출 된 메소드는 실행은 되지만 실제 MainViewConroller에 반영이 되지 않는다.

---------------

**-> 읽어온 데이터베이스가 저장된 변수 db는 새로 추가된 쿠폰을 가지고 있지 않기 때문이다. <-**

딜리게이트 또는 노티피케이션을 이용한 방법도 있지만 굳이 이것들을 사용하지 않아도 해결 할 수 있으리라 생각했다
viewWillAppear는 뷰가 나타날 때마다 호출이되므로 여기에서 데이터베이스를 업데이트 해주면 새로 추가된 쿠폰 디비를 읽어올 수 있었다.