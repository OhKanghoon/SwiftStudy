# 2. ARC (Automatic Reference Counting)



## 자동 참조 갯수 (ARC: Automatic Reference Counting)

> Swift는 앱의 메모리 사용을 추적하기 위해 `ARC`를 사용한다. 대부분의 경우 메모리 관리에 대해 생각할 필요가 없다.
>
> **`ARC`는 인스턴스가 더 이상 필요 없을 때 클래스 인스턴스에 사용된 메모리를 자동적으로 해제한다.**
>
> **하지만**, 몇가지 경우에 `ARC`는 메모리 순서에서 코드 부분들의 사이 관계에 대한 더 많은 정보가 필요하다.

(!) Reference Counting은 오직 클래스 인스턴스에만 적용 됩니다. (Struct, Enum은 Value Type)



## How to work ARC

* 클래스의 인스턴스가 생성될 때 `ARC`는 메모리를 할당해준다. 
* 클래스의 인스턴스가 더 이상 필요하지 않을 때 ARC는 할당된 메모리를 해제하여 다른 목적으로 쓰일 수 있도록 해준다.
* ARC는 아직 사용중인 인스턴스를 해제하지 않도록 주의를 기울인다. 만약 사용중인 인스턴스가 해제(deallocate)될 경우 인스턴스의 프로퍼티나 메서드에는 더 이상 접근할 수 없게 되서 Crash의 위험이 있기 때문이다.
* 따라서 ARC는 클래스 인스턴스를 참조하고 있는 프로퍼티들을 추적하고 **참조 횟수가 0이 되면 메모리를 해제한다**.
*  만약 강한(strong) 참조가 하나라도 있다면 해제하지 않는다. 

> 클래스 인스턴스가 프로퍼티, 상수, 변수 등에 할당될 때는 강한(strong) 참조가 되는데
>
> 강한 참조가 하나라도 걸려있다면 ARC는 해당 인스턴스가 사용중이라고 판단하여 해제를 하지 않는다



## 참조의 세 가지 방법

1. **strong** [default] : 값 지정 시점에 대입되는 값을 소유하고자 하는 의도가 있다고 판단하여 해당 객체의 레퍼런스 카운트를 1 올린다. 프로퍼티에서 그 객체를 다 사용하면 레퍼런스 카운트는 감소한다. **특정 클래스가 소유하고 관리하는 프로퍼티는 strong이 적당하다**.
2. **weak**: 자신이 참조는 하지만 **weak 메모리를 해제시킬 수 있는 권한은 다른 클래스에 있다**. 그래서 값 지정 시 레퍼런스 카운트를 올리지 않고, 언제 어떻게 메모리가 해제될 지 알 수가 없다. 다만 메모리가 해제될 경우 자동으로 레퍼런스가 nil로 초기화를 해 준다. nil이 될 수 있기 때문에 반드시 Optional 타입이 되어야 한다.
3. **unowned**: weak와 비슷하지만 **메모리가 해제되어도 레퍼런스가 초기화 되지는 않는다 (non-optional 타입)**





## ARC 사용하기

예시를 통해 Memory Leak을 발생시켜 해결해보자



### 강한 참조 순환



```swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}
 
class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
```



```swift
var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")
```



`Person` 과 `Apartment` 두 개의 Class를 만들었다.

`Person 클래스` 는 optional 하게 apartment를 가지고 `Apartment 클래스` 는 optional하게 tenant를 가진다.



두 클래스를 사용하여 `john` 과 ` unit4A` 두 개의 인스턴스를 만들어 보자

두 인스턴스를 생성하면 john은 Person 인스턴스에 대한 강한 참조를 가지고, unit4A는 Apartment 인스턴스에 대한 강한 참조를 지닌다.

![1](/images/ARC/1.png)

```swift
john!.apartment = unit4A
unit4A!.tenant = john
```

두 인스턴스를 연결하면 두 인스턴스간 `강한 참조주기` (strong reference cycle) 가 만들어진다.

따라서 `john` 을 참조 중단 하더라도 참조 수가 0으로 떨어지지 않기 때문에 **ARC**에 의해 할당 취소되지 않습니다.

![2](/images/ARC/2.png)



```swift
john = nil
unit4A = nil
```



`john` 과 `unit4A` 를 nil로 설정해서 위의 결과를 확인할 수 있다.



![3](/images/ARC/3.png)



`Person 인스턴스` 와 `Apartment 인스턴스`  사이의 **강한 참조**는 유지되며 파괴되지 않습니다.

이런 경우 **Memory Leak**이 발생하게 된다.



### Weak Reference 사용하기



```swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
```



```swift
var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john
```



이전의 예시와 다르게  `tenant` 가 weak 으로 선언된걸 확인할 수 있다.

`Person 인스턴스` 는 이전처럼 `Apartment 인스턴스` 에 대해 강한 참조를 가지고 있지만, `Apartment 인스턴스` 는 `Person 인스턴스` 에 대해 약한 참조를 가지고 있다. 

만약 `john 변수` 가 강한 참조를 중단한다면 `Person 인스턴스` 에 대한 **강한 참조**가 없어지게 된다.

![4](/images/ARC/4.png)



```swift
john = nil
```



`john` 을 nil로 변경하면

`Person 인스턴스` 에 대한 강한 참조가 없어지기 때문에 **할당이 해제**된다.

![5](/images/ARC/5.png)

이제 `Apartment 인스턴스` 에 대한 강한 참조는 `unit4A 변수` 에서만 나타납니다.



```swift
unit4A = nil
```



`unit4A` 를 nil로 변경하면

`Apartment 인스턴스` 에 대한 강한 참조가 없어지기 때문에 **할당이 해제**된다.

![6](/images/ARC/6.png)
