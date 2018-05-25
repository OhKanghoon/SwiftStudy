# 2. POP(Protocol Oriented Programming)



## 프로토콜(Protocol)

> `Protocol` 이란 작업에 필요한 메서드, 프로퍼티 및 요구사항을 정의하는 계약의 역할[^1]
>
> - 프로토콜은 함수/정수를 제공한다는 약속이다.
>
> 객체지향 언어의 인터페이스와 유사



#### Swift에서의 프로토콜

- **클래스**, **구조체**, **열거형** 모두 프로토콜을 따를 수 있다.

- 기본(Default Implementation) 구현 가능

  > **Extension**과 조합하여 강력한 기능을 발휘할 수 있다.
  >
  > 특정 타입이 할 일 지정 + 구현을 한번에

  ```swift
  protocol TestProtocol {}

  extension TestProtocol where Self: UIView {
      func viewPrint() {
          print(1111)
      }
  }

  extension TestProtocol where Self: UIButton {
      func buttonPrint() {
          print(2222)
      }
  }
  ```

- 프로퍼티를 정의할 경우 `읽기`, `쓰기` 타입을 반드시 명시해 주어야 한다.

  > { set } 만 구현할 수는 없다.

  ```Swift
  protocol A {
      var a: String { get set }
      var b: Int? { get }
  }
  ```

- **선택적 요구사항**

  ```swift
  @objc protocol B {
      func abc()
      @objc optional func def() -> Int
  }
  ```




#### 연관타입

> 구체적인 타입은 프로토콜을 구현한 타입에서 정한다.
>
> `associatedtype` : generic을 사용할 수 있게 한다.

- ```swift
  protocol HeaderViewProtocol {
      associatedtype Content
      func setHeader(data: Content)
  }

  class MyLabel: UILabel, HeaderViewProtocol {
      func setHeader(data: String) {
          self.text = data
      }
  }

  class MyImageView: UIImageView, HeaderViewProtocol {
    func setHeader(data: UIImage) {
      self.image = data
    }
  }
  ```

> `associatedtype` 으로 정의된 것은 하나 이상의 프로토콜을 따를 수 있다.

- ```swift
  protocol C {}

  protocol D {}

  extension D {
      var description: String {
          return "Hello world"
      }
  }

  protocol E {
      associatedtype F: C, D
      var name: F { get set }
  }

  extension E {
      mutating func set(name: F) {
          self.name = name
      }
      
      var description: String {
          return name.description
      }
  }
  ```





## POP(Protocol Oriented Programming)

> `POP` : 프로토콜 중심 프로그래밍



- **적용해야할 곳**

  > 함수가 1개 이상인 곳
  >
  > `dataSource`, `delegate`처럼 많이 쓰이는 경우
  >
  > - 중복을 최소화하기 위함.
  >
  > 여러 기능의 조합

- **적용하지 말아야할 곳**

  > 함수가 1개인 곳
  >
  > - 클로저로 넘겨주는 것이 더 깔끔한 코드가 될 수 있다.

  ​


### 장점

- **범용적인 사용**

  > **클래스**, **구조체**, **열거형** 모두 적용 가능
  >
  > 제네릭을 이용하여 하나의 타입으로 지정 가능

- **상속의 한계 극복**

  > 특정 상속 체계에 종속되지 않음
  >
  > 프레임워크에 종속적이지 않게 재활용 가능

- **적은 시스템 비용**

  > Reference type cost > Value type cost

- **용이한 테스트**

  > GUI 코드 없이도 수월한 테스트
