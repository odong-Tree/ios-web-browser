## 🐱GitHub

- 20/11/06 code

[wonhee009/ios-web-browser](https://github.com/wonhee009/ios-web-browser/tree/lasagna)

- 20/12/31 code

[wonhee009/ios-web-browser](https://github.com/wonhee009/ios-web-browser/tree/lasagna-develop)

## 🛠 Stack

- Swift

## 🖋 Review

```swift
extension String{
    var isNotValidate: Bool {
        let validateAddressPrefix = ["https://", "http://"]
        for validate in validateAddressPrefix {
            if self.hasPrefix(validate) {
                return true
            }
        }
        return false
    }
}
```

### Q. 코드의 뎁스를 줄이는 팁🌟이 있습니다. swift의 where절을 한번 찾아보세요

```swift
extension String {
    var isNotValidate: Bool {
        let validateAddressPrefix = ["https://", "http://"]
        for validate in validateAddressPrefix where self.hasPrefix(validate) {
            return true
        }
        return false
    }
}
```

[where 절](https://www.notion.so/where-ece2929080224d6cad8b9c41bd576baa) 

---

```swift
get {
	!self.isEmpty
}
```

### Q.  ✨ 연산 프로퍼티에 대해서는 get 키워드는 생략이 가능해요. 추가 고민거리 🧐연산프로퍼티와 인자가 없는 메소드는 어떤 차이가 있을까요?

[Property](https://www.notion.so/Property-792a47279a2248f68bd4efd69e5baa1b) 

---

## ⚙️ 추가 개선점 (20/11/06 → 20/12/31)

```swift
// 1차
enum ErrorMessage : String {
    case .converUrl = "url로 변환하는데 문제가 있습니다."
		case .moveForward = "앞으로 이동할 페이지가 없습니다."
		case .moveBack = "뒤로 이동할 페이지가 없습니다."
		case .loadPage = "페이지를 새로고침하는데 실패했습니다."
		case .emptyAddress = "이동하고 싶은 URL을 입력해주세요."
		case .validateAddress = "입력한 주소가 올바른 형태가 아닙니다."
}
```

```swift
// 2차
enum WebError: Error {
    case converUrl
    case moveForward
    case moveBack
    case loadPage
    case emptyAddress
    case validateAddress
    case unknow
}

extension WebError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .converUrl:
            return "url로 변환하는데 문제가 있습니다."
        case .moveForward:
            return "앞으로 이동할 페이지가 없습니다."
        case .moveBack:
            return "뒤로 이동할 페이지가 없습니다."
        case .loadPage:
            return "페이지를 새로고침하는데 실패했습니다."
        case .emptyAddress:
            return "이동하고 싶은 URL을 입력해주세요."
        case .validateAddress:
            return "입력한 주소가 올바른 형태가 아닙니다."
        case .unknow:
            return "알수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        }
    }
}
```

명시적으로 error `enum` 이름을 바꿨다.

`raw value`로 error message를 가져오는게 아니라 `computed property`로 message를 가져오도록 했다.

---

```swift
// 1차
func showErrorAlert(error: ErrorMessage) {
	let alert = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
	let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
	alert.addAction(confirmAction)
	present(alert, animated: false, completion: nil)
```

```swift
// 2차
extension UIViewController {
    func showError(_ error: Error) {
        let alert: UIAlertController
        if let webError = error as? WebError {
            alert = UIAlertController(title: nil, message: webError.errorDescription, preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: nil, message: WebError.unknow.errorDescription, preferredStyle: .alert)
        }
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirmAction)
        self.present(alert, animated: false, completion: nil)
    }
}
```

추후 확장성을 위해 `UIViewController` extension을 만들었다.

따라서 `UIViewController`를 상속받으면 해당 func로 error alert을 띄울 수 있다.

범용적으로 `Error`를 처리하고 싶어 파라미터는 Error protocol로 지정했다.

그 안에서 타입 캐스팅으로 `WebError`를 처리해줬다.

---

```swift
// 1차
@IBAction func goBack() {
	if webView.canGoBack {
		webView.goBack()
	}
	else {
		showErrorAlert(error: .moveBack)
	}
}
```

```swift
// 2차
@IBAction func goBack() {
	guard webView.canGoBack else {
		return self.showError(WebError.moveBack)
	}
	webView.goBack()
}
```

`guard`문을 사용해 뎁스를 줄이고 길이를 줄였다.

또한, `guard`문으로 웹뷰 페이지를 이동할 수 없을 경우 빠르게 탈출할 수 있도록 했다.
