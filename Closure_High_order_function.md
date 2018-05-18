# 1. 클로저 / 고차함수



## 클로저(Closure)

> `Closure`란 한 번만 사용하기 위한 일회용 함수를 작성할 수 있는 구문
>
> 자신이 정의되었던 문맥으로부터 모든 상수와 변수의 값을 캡쳐하거나 레퍼런스를 저장한다.



Closure : 특정 태스크를 수행하기 위해 사용될 수 있는 각종 기능들의 개별 묶음

함수 : `Closure`의 특별한 종류 (이름 있는 Closure라고 할 수 있음)



* **형태**

  ```swift
  { (param1(인자): Int(타입), param2: String) -> Void(리턴타입) in
      return 리턴값
  }
  ```

* **클로저 식 예제**

  ```swift
  // 배열 정렬하기
  let numbers = [1,4,56,22,5]
  
  // (함수 사용)
  func sortAscending(_ i: Int, _ j: Int) -> Bool {
      return i < j
  }
  let sortedNumbers = numbers.sorted(by: sortAscending)
  
  // (클로저 사용)
  let sortedNumbers = numbers.sorted(by: { (i: Int, j: Int) -> Bool in
      return i < j
  })
  ```

* 스위프트는 클로저의 타입을 **문맥으로부터 추론해 결정**한다. 클로저에서 `타입`, `반환 타입`, `return`을 제거해보자!

  ```swift
  let sortedNumbers = numbers.sorted(by: { i, j in i < j })
  ```

* **축약형 인수명** 문법 구조 적용하기

  > 매개변수 이름을 사용하지 않고, 인자로 넘어오는 순서대로 $0, $1, ...를 사용하면 in과 매개변수 목록도 없앨 수 있다.

  ```swift
  let sortedNumbers = numbers.sorted(by: { $0 < $1 })
  ```

  두 인자를 받아서 연산자에 넘기는 경우 `<` 연산자를 바로 넘겨도 된다.

* **후행 클로저**

  ```swift
  let sortedNumbers = numbers.sorted() { $0 < $1 }
  
  // 메서드의 소괄호까지 생략 가능
  let sortedNumbers = numbers.sorted { $0 < $1 }
  ```

  



## 고차함수

> 하나 이상의 함수를 인자로 취하거나 함수를 결과로 반환하는 함수
>
> * **map**
>
> * **filter**
> *  **reduce**



### map

컬렉션 내부의 기존 데이터를 변형해서 새로운 컬렉션을 생성하는 함수 

> 기존 for문 사용

```Swift
let numbers: [Int] = [0, 1, 2, 3, 4]
var doubledNumbers: [Int] = [Int]()
var stringsNumbers: [String] = [String]()

for number in numbers {
    doubledNumbers.append(number * 2)
    stringsNumbers.append("\(number)")
}

print(doubledNumbers) // [0, 2, 4, 6, 8]
print(stringsNumbers) // ["0", "1", "2", "3", "4"]
```

> **map** 사용

```swift
doubledNumbers = numbers.map({ (number: Int) -> Int in
    return number * 2
})
```

> 위에서 배웠던 축약을 사용해보자

```swift
doubledNumbers = numbers.map { $0 * 2 } // [0, 2, 4, 6, 8]
```



### filter

컨테이너 내부의 값을 걸러서 추출하는 함수

> 기존 for문 사용

```swift
let numbers: [Int] = [0, 1, 2, 3, 4, 5]
var evenNumbers: [Int] = [Int]()

// for 구문 사용, 짝수 골라냄
for number in numbers {
    if number % 2 != 0 { continue }
    evenNumbers.append(number)
}

print(evenNumbers) // [0, 2, 4]
```

> **filter** 사용

```swift
let evenNumbers: [Int] = numbers.filter { (number: Int) -> Bool in
    return number % 2 == 0
}
```

> 위에서 배웠던 축약을 사용해보자

```swift
let evenNumbers: [Int] = numbers.filter { $0 % 2 == 0 }
```



### Reduce

컨테이너 내부의 콘텐츠를 하나로 통합하는 함수

> 기존 for문 사용

```swift
let numbers: [Int] = [1, 3, 5]
var sum: Int = 0
for number in numbers {
    sum += number
}

print(sum) // 9
```

> **reduce** 사용

```swift
// 초깃값이 0이고 정수 배열의 모든 값을 더함
let sum: Int = numbers.reduce(0, { (first: Int, second: Int) -> Int in
    // log를 확인해보자
    print("\(first + second)")
    return first + second
})

print(sum) // 9
```

> 위에서 배웠던 축약을 사용해보자

```swift
let sum: Int = numbers.reduce(0) { $0 + $1 } // 9
```

### 
