# Coupon

## 쿠폰 추가 화면

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



 