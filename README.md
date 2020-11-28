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

