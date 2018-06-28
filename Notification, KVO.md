# Notification Center, KVO

## Notification Center

**What is Notification Center**
 - 등록된 관찰자에게 정보(데이터)를 브로드캐스트(전달) 할 수 있는 통지&발송 메커니즘.(애플 공식문서 번역)
 - 일반적으로 이벤트 발생에 따른 클래스간 데이터 전달을 위해 사용
 
 **Overview**
 - NotificaionCenter에 등록된 데이터를 addObserver(_:selector:name:object:)또는 addObserver(NSNotification개체)를 구현함으로써 수신.
 - 객체는 여러가지 다른 notification에 대한 observer로 등록하기 위해 여러번 addObserver method를 호출할 수 있음.
 - 실행 중인 각 앱에는 기본 알림 센터(Notificationcenter)가 있으며, 사용자는 새 notification center 를 만들어 특정 컨텍스트에서 통신을 구성할 수 있음.
 - notification center는 단일 프로세스 내에서만 알림을 전달할 수 있고  다른 프로세스에 알림을 post하거나 다른 프로세스로부터 알림(정보 수신)을 받으려면 DistributedNotification Center를 사용해야함.
 
 **Implementation**
- Notification Center 라는 싱글턴 객체를 통해서 이벤트들의 발생 여부를 옵저버를 등록한 객체들에게 Notification을 post하는 방식으로 사용. Notification name 이라는 key 값을 통해 보내고 받을 수 있음.
 - 여러객체에서 하나의 이벤트 발생에 대해 여러개의 객체에 동시에 알려줄 수 있음
 -> 데이터를 전달해주는 A 객체에서 ***NotificationCenter.default.post(name: object: userInfo:)*** 메서드를 통해 보내고자 하는 데이터를 브로드 캐스트하면 해당 알림을 감지할 필요가 있는 다른 객체들(B,C,D)에서  ***addObserver(self, selector: name:  object:)*** 메서드를 구현을 통해 브로드캐스트 하는 데이터를 딕셔너리 타입으로 받아올 수 있음(ex.userInfo[AnyHashable:Any]?)
 
- [공식문서](https://developer.apple.com/documentation/foundation/notificationcenter)

## KVO(Key Value Observing)

**what is KVO**
-  객체가 다른 객체의 특정 속성에 대한 변경 사항을 알리는 메커니즘을 제공.

**Oviewview**
- KVO는 애플리케이션에서 모델 계층과 컨트롤러 계층 간의 통신에 특히 유용함. 일반적으로 컨트롤러 객체는 모델 객체의 속성을 관찰하고 view 객체는 컨트롤러를 통해 모델 개체의 속성을 관찰함. 즉 Model에 어떤 변화가 발생할 경우 Controller에서 이것을 감지한뒤 적절한 비즈니스 로직을 거쳐 View를 갱신할 수 있음을 의미함.

**keyPath**
클래스(객체)의 멤버(프로퍼티나 메소드 등)를 특정 문자열로 표기하는 규칙이다.
예를 들어 UIScrollView addObserver method의 키패스에 인자로 "contentOffset" 라는 문자열을 넘겨주면 UIScrollView 클래스 및 객체의 contentOffset 라는 프로퍼티를 의미하는 것으로 이해할 수 있음

**Implementation**

1. Resgistering as an Observer
***addObserver(_:forKeyPath:options:context:)*** 메서드로 감지하려는 객체에 옵저버를 등록하며 전달받는 인자는 다음과 같은 역할을 한다.
- observer: KVO 이벤트를 감지하는 객체를 의미하며 이 객체는 observeValue(forKeyPath:of:change:context:)를 구현해 이벤트를 받는다.
- keyPath: 감지하려는 프로퍼티의 keyPath를 String 타입으로 전달한다.
- options: NSKeyValueObservingOptionsenum 값의 배열이며 new, old, initial, prior의 네 가지로 이루어져 있다. 이 값들을 조합해 언제 이벤트 알림을 보낼지 결정한다.
- context: 외부 변수의 포인터 값을 전달하며 알림이 온 정확한 위치를 알려주는 역할을 한다. nil 값을 전달하면 오로지 keyPath로 알림이 온 위치를 식별한다. 그러나 상위 클래스와 하위 클래스가 같은 프로퍼티를 감지할 경우 문제가 발생할 수 있다.

2. Receiving Notification of a Change
***observeValueForKeyPath:ofObject:change:context:)*** 메서드로 객체의 변화가 일어났을 때 옵저버의 메시지를 받는다. 각 인자는 다음과 같은 역할을 함.
keyPath: 바뀐 프로퍼티의 위치를 나타내며 여러 프로퍼티를 감지할 경우에 이 인자 값으로 구분할 수 있다.
object: keyPath가 어떤 객체에 있는지 알려줌.
change: [NSKeyValueChangeKey : Any]? 타입의 Dictionary로 전달되며 옵저버 등록 시 options에 넣은 값들이 키값으로 하여 그것에 해당하는 값을 알려줌.
context: 위에서와 마찬가지로 keyPath와 함께 사용시 좀 더 안전한 감지와 처리가 가능.


3. Removing an Object as an Observer
***removeObserver:forKeyPath:context:*** 메서드를 통해 프로퍼티에 달아둔 옵저버를 제거한다. 옵저버를 해제하는 것에 대해 몇 가지 유의해야 할 점이 있다.

아직 등록되지 않은 옵저버를 해제하는 것은 NSRangeException을 야기한다. 하나의 addObserver(_:forKeyPath:options:context:)에 하나의 removeObserver:forKeyPath:context:를 호출해야 하며 앱 내에서 실행이 가능하지 않은 경우 try-catch 구문 안에서 해제해야 한다.
옵저버는 자동적으로 메모리에서 해제되지 않는다. 감지당하는 객체는 계속해서 감지하는 객체의 상태를 신경쓰지 않고 메시지를 보내는데 만약 감지하는 객체가 메모리에서 해제되었을 경우 메모리 접근 에러가 일어날 것이다. 그러므로 메모리에서 해제해주는 것이 중요하다.
프로토콜은 어떤 객체가 감지하는지 또는 감지당하는지에 대해 물어보지 않는다. 일반적으로 감지하는 객체의 초기화 시(init / viewDidLoad) 옵저버를 등록하고 메모리 해제 시(dealloc) 같이 해제를 한다.

**Key Value Coding**
- Key-Value Coding은 NSKeyValueCoding 프로토콜을 따르는 객체에 간접적으로 접근할 수 있게 하는 기법.
- 이러한 객체는 문자열을 파라미터로 손쉽게 어디서든 접근이 가능
- 일반적으로 NSObject를 직접적, 간접적으로 상속하는 객체들은 자동적으로 NSKeyValueCoding 프로토콜을 따름
- Swift에서 KVC 패턴은 Objective-C보다 많이 쓰이지는 않음.
- NSKeyValueCoding의 많은 메서드들이 Swift와 맞지 않는 경우가 있고 또한 Swift에서 더 효과적인 기법들이 존재하기 때문(didSet,willSet).
- UIScrollView와 같이 이미 UIKit 모듈에 **이미 정의되어있는** 클래스의 프로퍼티(contentOffset) 값을 탐지하거나 변경할 때 유용
- Swift에서는 단순히 특정클래스의 프로퍼티 변화를 추적할때는 didSet 또는 willSet이 더 나은 방법이 될 수 있어보임.

```swift

class SomeClass: NSObject {
@objc dynamic var value: String = ""
}

let someObject = SomeClass()

someObject.observe(\.value) { (object, change) in
print("SomeClass object value changed to \(object.value)")
}

someObject.value = "test"  // TEST
```
-  value 앞에는 dynamic 이라는 수식어가 붙어있는데 이는 dynamic dispatch 를 활성화 시키는 오퍼레이터다
-  dynamic 키워드가 적용된 것은 스위프트 런타임 대신에 Objective-C 런타임을 사용하여 메시지를 전송한다는 것을 의미.
자세한 사항은 아래 링크를 참고
[스위프트 dynamic](https://outofbedlam.github.io/swift/2016/01/27/Swift-dynamic/)
[dynamic dispatch로 메서드(Method)가 호출되는 과정](http://blog.naver.com/PostView.nhn?blogId=horajjan&logNo=220956348099)



```swift

class SomeClass: NSObject {
var value: String = ""{
        print("SomeClass object value changed to \(value)")
    }
}
let someObject = SomeClass()
someObject.value = "test"  // TEST

```




위 처럼 Swift에서 iOS 시스템 설정을 변경해야 할 때 쓰일 수 있음


- [공식문서 & Programming  Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html)


## [Notification과 KVO의 장단점 및 차이점](https://wnstkdyu.github.io/2018/01/19/threepattern/)

>https://developer.apple.com/documentation/foundation/notificationcenter)
>
>http://seorenn.blogspot.com/2017/07/swift-4-kvo.html
>
> https://wnstkdyu.github.io/2018/05/01/kvoprogrammingguide/
>
>http://seorenn.blogspot.com/2017/07/kvo-key-value-observing.html?m=1

