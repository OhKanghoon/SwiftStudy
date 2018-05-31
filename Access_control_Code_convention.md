# 3-1. 접근제어(Access Control)



## 접근 제어

> `Access Control` 이란 다른 소스파일이나 모듈에서, 개별 객체나 속성에 대한 접근을 접근 제어자를 통해 단계별로 허용하거나 차단 하는 것  



## 들어가기 전에

> 스위프트의 접근 제어 모델은 모듈과 소스파일의 개념을 기반으로 함.
>
> 따라서 모듈과 소스파일에 대한 이해가 필요
>
> - 모듈  : 배포할 코드의 묶음 단위. 우리가 만드는 Xcode Project 역시 하나의 모듈이며 import 키워드를 통해 외부 모듈(프레임워크, 앱 등)을 해당 프로젝트에서 사용 가능함. 
>
>   ex)  import UIKit
>
>   ​	import Foundation
>
> - 소스 파일 : 모듈 안에 있는 스위프트 소스 코드 파일. 
>
>   ex) AppDelegate.swift
>
> 접근 제어를 적용할 수 있는 것들은 프로퍼티, 타입, 함수, 초기화, 서브스크립트 등이 있으며 이하 ‘요소들’이라고 지칭 



## 접근 레벨 (Access Level) 

* Swift 에서는 5가지의 접근 레벨이 존재
1. open
2. public
3. internal
4. fileprivate
5. private

> **`open`** 접근이 가장 높은(제한을 최소화) 접근 레벨이고, **`private`** 접근은 가장 낮은(제한이 가장많음) 접근 레벨. 

* 이러한 접근 레벨은 요소가 정의된 소스파일이나, 모듈과 관련 됨. 

* 하나의 요소에 대한 접근 레벨 정의는 이 중 하나를 요소의 앞에 배치하면 됨.  

 ~~~swift
  open class SomeOpenClass {}
  public var somePublicVariable = 0
  internal let someInternalConstant = 0
  fileprivate func someFilePrivateFunction() {}
  private func somePrivateFunction() {}
 ~~~

* 이때 명시적으로 접근 레벨을 지정하지 않은 경우에, 암시적으로 **`internal`** 기본 접근 레벨(Default Access Levels) 제공 

 ~~~swift
  class SomeInternalClass {}              // implicitly internal
  let someInternalConstant = 0            // implicitly internal
 ~~~



#### open/public

* 공통점

  >내,외부 모듈의 모든 소스파일에서 모두 사용 가능

* 차이점

  >| open                                                         | public                                                       |
  >| ------------------------------------------------------------ | ------------------------------------------------------------ |
  >| 외부 모듈에서도 상속 가능                                    | 외부 모듈에서는 상속 불가                                    |
  >| 외부 모듈에서 오버라이딩 가능                                | 외부 모듈에서 오버라이딩 불가, 오로지 참조에 의한 사용만 가능 |
  >| 클래스와 오버라이드 가능한 클래스 멤버들만이 `open`으로 선언될 수 있음  ex) open struct , open enum 불가 |                                                              |
  >
  >* ExternalModule
  >
  >~~~swift
  >open class ExternalOpenClass {
  >    open func externalOpenFunc() {}
  >    public func externalPublicFunc() {}
  >}
  >
  >public class ExternalPublicClass {    
  >    public func externalPublicFunc() {}
  >}
  >
  >~~~
  >
  >* InternalModule
  >
  >~~~swift
  >import ExternalModule
  >
  >class SubExternalOpen: ExternalOpenClass {
  >    
  >    //가능
  >    override func externalOpenFunc() {
  >        print("DO SOMETHING")
  >    }  
  >    
  >    //오버라이드 불가
  >    /*override func externalPublicFunc() {
  >        <#code#>
  >    }*/
  >}
  >
  >//상속 불가
  >/*class subExternalPublic: ExternalPublicClass {
  >    
  >}*/
  >~~~
  >



#### internal

>내부 모듈의 모든 소스파일에서 요소들 사용 가능

#### fileprivate

> 정의된 소스파일에서만 요소를 사용할수 있도록 제한 

#### private

> 선언된 영역(enclosing)에서만 요소를 사용할 수 있도록 제한 

~~~swift
class InternalClass {
    fileprivate func filePrivateFunc() {}
    private func privateFunc() {}
}

func accessStuff() {
    let myInternal = InternalClass()
    //가능
    myInternal.filePrivateFunc()
    //불가
    /*myInternal.privateFunc()*/
}
~~~



## 사용자 정의 타입(Custom Types)

* 사용자정의 타입에 대해 명시적인 접근 레벨을 지정하길 원하면, 타입을 정의하는 시점에 해야 함.

*  이때 타입의 접근 제어 레벨은 타입의 멤버(프로퍼티, 메소드, 초기화, 서브스크립트)의 기본 접근 레벨에 영향을 미침.

  **`private`** 또는 **`file private`** 으로 타입의 접근 제어 레벨을 정의하면, 멤버들의 기본 접근 레벨은 **`private`** 또는 **`file private`** 이 될 것. 

  > **주의** : private class의 멤버라고 해서 그 멤버 자체의 접근 레벨이 private이 된다는 것이 아니라, private class 안에 들어 있는 것이기 때문에 기본 접근 레벨에 영향을 미치는 것. 

  ~~~swift
  fileprivate class FilePrivateClass {
      func internalFunc() {}
  }
  ~~~

  > 여기서 internalFunc 의 접근레벨은 internal 이지만 class의 접근 레벨이 fileprivate 이기 때문에 다른 소스파일에서 해당 메소드 접근 불가



## 튜플 타입

* 튜플 타입의 접근 레벨은 튜플 구성 타입의 최소 접근 레벨로 자동 추론 됨.



## 함수 타입

* 함수 타입에 대한 접근 레벨은 함수의 매개변수 타입과 반환 타입중 가장 제한적인 접근 레벨로 계산 됨. 

* 함수의 계산된 접근 레벨이 컨텍스트(contextual)의 기본값과 일치하지 않은 경우, 함수 정의에서 명시적으로 접근 레벨 지정 필요. 

  ~~~swift
  //불가
  /*func someFunction() -> (SomeInternalClass, SomePrivateClass) {
      // function implementation goes here
  }*/
  ~~~

  >해당 함수의 반환 타입은 두개의 사용자 정의 클래스로 구성된 튜플 타입. 
  >
  >여기서 튜플타입의 접근 레벨은 `private`(튜플 구성 타입의 최소 접근 레벨)
  >
  >즉 함수의 반환 타입이 private이기 때문에 함수의 선언이 유효하기 위해서는 함수 접근 레벨 `private`으로 지정

  ~~~swift
  //가능
  private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
      // function implementation goes here
  }
  ~~~



## 열거형 타입

* 열거형의 각 **`case`** 들은 자동적으로 열거형과 같은 레벨을 받음

* 열거형의 각 **`case`** 들에 대한 접근 레벨을 다르게 지정할수 없음

  ~~~swift
  //case들의 접근 레벨은 모두 public
  
  public enum CompassPoint {
      case north
      case south
      case east
      case west
  }
  ~~~

  

## 서브클래스

* 서브클래스는 슈퍼클래스보다 높은 접근 레벨을 가질수 없음

  ~~~swift
  internal class InternalClass {
   }
   
   //불가
  /*public class PublicClass: InternalClass {
     }*/
  
  ~~~

* 오버라이드(override)는 상속된 클래스 멤버를 슈퍼클래스 버전보다 더 접근성 있게 만들수 있음.

  ~~~swift
  public class PublicClass {
      fileprivate func someMethod() {}
  }
  
  internal class InternalClass: PublicClass {
      override internal func someMethod() {}
  }
  ~~~



## 상수, 변수, 프로퍼티, 서브스크립트 

* 상수, 변수, 프로퍼티는 타입보다 더 **`public`** 할 수 없음.

  즉,  **`private`** 타입으로 **`public`** 프로퍼티를 작성하는 것은 유효하지 않음.

  ~~~swift
  //가능
  private let myPrivateClass = FilePrivateClass()
  //불가
  /*public let myPublicClass = FilePrivateClass()*/
  ~~~



## Getter & Setter

* 상수, 변수, 프로퍼티, 서브스크립트에 대한 **`getter`** 들과 **`setter`** 들은 자동으로 그가 속한 것과 같은 접속 레벨.

* 변수, 프로퍼티, 서브스크립트의 읽기-쓰기를 제한하기 위해, **`setter`** 에 해당 **`getter`** 보다 낮은(lower) 접근 레벨을 줄 수 있음

  ~~~swift
  struct TrackedString {
      private(set) var numberOfEdits = 0
      var value: String = "" {
          didSet {
              numberOfEdits += 1
          }
      }
  }
  ~~~

  > 다른 소스파일에서 `numberOfEdits` 프로퍼티의 현재 값을 조회할수 있지만, 수정은 불가 
  >
  > ~~~swift
  > var stringToEdit = TrackedString()
  > stringToEdit.value = "This string will be tracked."
  > stringToEdit.value += " This edit will increment numberOfEdits."
  > stringToEdit.value += " So will this one."
  > print("The number of edits is \(stringToEdit.numberOfEdits)")
  > 
  > //불가
  > /*stringToEdit.numberOfEdits = 5 */
  > ~~~

* 필요한 경우, **`getter`** 와 **`setter`** 모두에 대한 명시적인 접근 레벨 할당 가능.  

  ~~~swift
  public struct TrackedString {
      public private(set) var numberOfEdits = 0
      public var value: String = "" {
          didSet {
              numberOfEdits += 1
          }
      }
      public init() {}
  }
  ~~~

  

## 초기화

* 사용자정의 초기화의 접근 레벨은 초기화된 타입과 같거나 낮게 할당 가능.
* 필수 초기화는 예외적으로 초기화가 속한 클래스와 같은 접근 레벨을 가짐.



## 기본 초기화

* 기본 초기화는 타입을 **`public`** 으로 정의하지 않으면, 초기화하는 타입과 같은 접근 레벨을 가짐.

* **`public`** 으로 정의된 타입의 경우, 기본 초기화는 **`internal`**

  따라서 **`public`** 타입을 다른 모듈에서 사용시, 기본 초기화 이용하려면 타입 정의시에 **`public`** 접근 레벨의 기본 초기화 제공 필요.

  * ExternalModule

  ~~~swift
  public struct TrackedString {
      private (set) var numberOfEdits = 0
      public var value: String = "" {
          didSet {
              numberOfEdits += 1
          }
      }
      public init(){   
      }
  }
  ~~~

  * InternalModule

  ~~~swift
   var tracked = TrackedString() 
  ~~~




## 프로토콜

* 프로토콜 내의 요구 사항에 대한 접근 레벨은 프로토콜과 같은 접근 레벨로 자동으로 설정. 

* 지원하는 프로토콜과 다른 접근 레벨로 프로토콜 요구사항을 설정 불가.

  ~~~swift
  //불가
  /*fileprivate protocol myProtocol {
      private func doSomethingWithProtocol()
  }*/
  ~~~

   

## 프로토콜 상속

* 기존 프로토콜로부터 새로운 프로토콜 상속을 정의하면, 새로운 프로토콜은 상속된 프로토콜보다 높은 접근 레벨을 가질 수 없음

  ~~~swift
  internal protocol InternalProtocol {
    func doSomethingWithProtocol()
  }
  
  //불가
  /*public protocol PublicProtocol : InternalProtocol {
     
  }*/
  ~~~

  

## 확장

* 타입을 확장할 때, 타입과 같은 기본 접근 레벨을 가지도록 멤버를 추가

* 확장내의 모든 멤버 정의에 새로운 기본 접근 레벨을 설정하기 위해, 명시적으로 접근 레벨을 수정하여 확장 표현 가능

  ~~~swift
  //Access1.swift
  
  internal class InternalClass {
  	func doSomethingInternal(){}
  }
  
  fileprivate extension InternalClass {
      func doSomethingFilePrivate() {}
  }
  ~~~
  ~~~swift
  //Access2.swift
  
  func accessStuff(){
      let myClass = InternalClass()
      //가능
      myClass.doSomethingInternal()
      //불가
      /*myClass.doSomethingFilePrivate()*/
  }
  ~~~










# 3-2. 코드 컨벤션(Code Convention)



## General Conventions

* #### case convention 따르기

  > * 타입이나 프로토콜의 이름은 UpperCamelCase로, 그 외는 모두 lowerCamelCase 로 사용
  >
  > * 주로 upper case로 사용되는 [약자나 이니셜](https://en.wikipedia.org/wiki/Acronym)들은 case convention 에 따라 일관적으로 up/down case 로 표현 되어야 함
  >
  >    ~~~swift
  >    var utf8Bytes: [UTF8.CodeUnit]
  >    var isRepresentableAsASCII = true
  >    var userSMTPServer: SecureSMTPServer
  >    ~~~
  >
  > * 그 외의 약자들은 일반 단어처럼 취급
  >
  >    ~~~swift
  >    var radarDetector: RadarScanner //Radio Detection and Ranging
  >    var enjoysScubaDiving = true //Self Contained Underwater Breathing Apparatus
  >    ~~~

  #### 

* #### 함수는 기본적으로 수행하는 역할이 같거나, 서로 다른 영역에서 사용 될 때 그 이름을 공유할 수 있음

  > * 아래와 같은 코드는 근본적으로 같은 기능을 하기 때문에 다음과 같은 이름이 지향됨
  >
  >   ~~~swift
  >   extension Shape {
  >     /// Returns `true` iff `other` is within the area of `self`.
  >     func contains(_ other: Point) -> Bool { ... }
  >   
  >     /// Returns `true` iff `other` is entirely within the area of `self`.
  >     func contains(_ other: Shape) -> Bool { ... }
  >   
  >     /// Returns `true` iff `other` is within the area of `self`.
  >     func contains(_ other: LineSegment) -> Bool { ... }
  >   }
  >   ~~~
  >
  >  * 하지만 아래의 index 메소드들은 다른 의미를 가지고 있기 때문에, 다른 이름으로 정의 되어야 함
  >
  >    ~~~swift
  >    extension Database {
  >      /// Rebuilds the database's search index
  >      func index() { ... }
  >    
  >      /// Returns the `n`th row in the given table.
  >      func index(_ n: Int, inTable: TableID) -> TableRow { ... }
  >    }
  >    ~~~
  >
  >  * 리턴 타입을 이용한 오버로딩을 피해야하는데, 이는 타입 추론에서 모호함을 유발하기 때문
  >
  >    ~~~swift
  >    extension Box {
  >      /// Returns the `Int` stored in `self`, if any, and
  >      /// `nil` otherwise.
  >      func value() -> Int? { ... }
  >    
  >      /// Returns the `String` stored in `self`, if any, and
  >      /// `nil` otherwise.
  >      func value() -> String? { ... }
  >    }
  >    ~~~
  >



## 파라미터

* #### 정보 관리를 원활히 할 수 있는 파라미터 이름을 선정

  > 아래 코드에 사용된 파라미터 이름은 문서를 읽는 것을 한결 용이하게 함
  >
  > ~~~swift
  > /// Return an `Array` containing the elements of `self`
  > /// that satisfy `predicate`.
  > func filter(_ predicate: (Element) -> Bool) -> [Generator.Element]
  > 
  > /// Replace the given `subRange` of elements with `newElements`.
  > mutating func replaceRange(_ subRange: Range, with newElements: [E])
  > ~~~

* #### 기본 매개변수 (Default Parameter)의 이점 취하기

  > Default argument 는 관련성 없는 정보들을 숨김으로써 가독성을 향상 시킴
  >
  > ~~~swift
  > //default parameter 없을 때 
  > let order = lastName.compare(
  >   royalFamilyName, options: [], range: nil, locale: nil)
  >   
  > //default parameter 있을 때 
  > let order = lastName.compare(royalFamilyName)
  > ~~~
  >
  > ~~~swift
  > extension String {
  >   /// ...description...
  >   public func compare(
  >      _ other: String, options: CompareOptions = [],
  >      range: Range? = nil, locale: Locale? = nil
  >   ) -> Ordering
  > }
  > ~~~

* #### 디폴트 값이 있는 파라미터들은 파라미터 리스트의 마지막에 둠

  

## Argument Labels

- #### 인자가 유의미하게 구분될 수 없다면 모든 argument label 을 제거

  `min(number1, number2)`

  `zip(sequence1, sequence2) `

- ####  값을 보존하는 타입 변환을 수행하는 이니셜라이저에서는 첫번째 argument label 제거

  `Int64(someUInt32)`

  >* 첫번째 인자는 언제나 전환의 소스가 되어야 함
  >
  >  ```swift
  >  extension String {
  >    // Convert `x` into its textual representation in the given radix
  >    init(_ x: BigInt, radix: Int = 10)   ← Note the initial underscore
  >  }
  >  
  >  text = "The value is: "
  >  text += String(veryLargeNumber)
  >  text += " and in hexadecimal, it's"
  >  text += String(veryLargeNumber, radix: 16)
  >  ```
  >
  >  
  >
  > * 하지만 값을 축소(narwwoing)하는 타입 변환에서는 축소를 설명하는 label이 권장됨
  >
  >   ~~~swift
  >   extension UInt32 {
  >     /// Creates an instance having the specified `value`.
  >     init(_ value: Int16)            ← Widening, so no label
  >     /// Creates an instance having the lowest 32 bits of `source`.
  >     init(truncating source: UInt64)
  >     /// Creates an instance having the nearest representable
  >     /// approximation of `valueToApproximate`.
  >     init(saturating valueToApproximate: UInt64)
  >   }
  >   ~~~

- #### 첫번째 인자가 전치사구의 부분이 될 때 argument label 을 사용  

  > * argument label은 일반적으로 전치사부터 시작
  >
  >   `x.removeBoxes(havingLength: 12)` 
  >
  > * 처음에 나타나는 두 인자가 모호함을 발생시킬 때 문제
  >
  >   `a.move(toX: b, y: c)`
  >
  >   `a.fade(fromRed: b, green: c, blue: d)`
  >
  >   이럴때는 argument label 을 전치사 뒤부터 설정하는 방법을 통해 모호함 제거
  >
  >   `a.moveTo(x: b, y: c)`
  >
  >   `a.fadeFrom(red: b, green: c, blue: d)`
  >

- ####  만약 첫번째 인자가 **grammatical phrase**를 만들때는 label을 제거  

  > `x.addSubview(y)`

  > * 이는 만약 첫번째 인자가 grammatical phrase를 형성하지 않는다면 레이블을 가져야한다는 의미를 내포함
  >
  > ~~~swift
  > view.dismiss(animated: false)
  > let text = words.split(maxSplits: 12)
  > let studentsByName = students.sorted(isOrderedBefore: Student.namePrecedes)
  > ~~~
  >
  > * 구는 의미를 명확하게 전달해야 함
  >
  >   다음은 문법적이더라도 의미가 불명확
  >
  > ~~~swift
  > view.dismiss(false)   Do not dismiss? Dismiss a Bool?
  > words.split(12)       Split the number 12?
  > ~~~

- #### 다른 모든 인자에 대해서는 label 설정