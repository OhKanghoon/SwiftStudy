# 9. iOS 아키텍처

### 좋은 아키텍처란?
* 각각의 객체들은 구체적이고 명확한 역할을 가져야 함
* 테스트 가능성
* 사용의 용이성, 낮은 유지 보수 비용
* 단순한 데이터 흐름. 쉬운 디버깅
* 관심사의 분리

# 9-1. MVC (Model-View-Controller)

>`MVC`는  가장 널리 사용된 디자인 패턴 중 하나

## MVC패턴의 특징
- Model과 View, 그리고 Controller 세가지 요소로 구성 되어 있음
- Model과 View를 완전히 분리시켜 이들의 재사용성을 높임
- 스파게티 코드 방지

![](/images/Architecture/MVC.png)

## Model
 앱의 비즈니스 로직과 데이터를 관장하는 영역

## View
 유저에게 데이터를 보여주거나, UI를 담당하는 영역

> View는 '어떻게' 보여질 지에 대해서만 관장하고, '어떤 것'을 보여줄 지에 대해서는 알지 못함

## Controller
 View와 Model을 이어주는 역할

> Model에 저장될 데이터와, View에서 보여질 데이터를 업데이트하고 컨트롤함
>
> Model 데이터가 변하면, Controller에게 Notify
>
> View에 유저 액션이 들어올 경우, Controller에게 Delegate

## MVC의 단점
* View Controller의 코드가 비대해짐
* View Controller는 View의 라이프 사이클과 강하게 엮여 있어, 재사용이 불가능
* View와 Controller의 상호작용 (user action과 그에 따른 로직)은 unit test에서 테스트할 수 없음

![](/images/Architecture/MVC2.png)


# 9-2. MVVM (Model-View-ViewModel)

>`MVVM`은 Model과 View, 그리고 View Model 로 구성된 소트트웨어 아키텍처 패턴

## MVVM패턴의 특징
**View와 View Model 간의 데이터바인딩**
- Method call이 아닌 Data-Binding을 통한 상호작용
- View Model이 Model을 통해 데이터를 받아와 변경사항을 View에 바로 적용
- View Model은 Presentation Logic을 다룸, 하지만 UI는 다루지 않음(UIKit import 금지)
- User Interaction이 잦고 많은 소프트웨어에서 유용

![](/images/Architecture/MVVM.png)

## View Model
View를 표현하기 위해 만들어진 View를 위한 Model
> Model에서 변경을 호출하고 Model 자체를 갱신함 
>
> 따라서 View나 View Model 사이에서 바인딩을 함
>
> * **`Command`** 패턴과 **`data Binding`** 패턴
>
> 두가지 패턴으로 인해 View와 ViewModel은 의존성이 완전히 사라지게 됨
>
> 1. View에 입력이 들어오면 Command 패턴으로 ViewModel에 명령을 합니다.
> 2. ViewModel은 필요한 데이터를 Model에 요청 합니다.
> 3. Model은 ViewModel에 필요한 데이터를 응답 합니다.
> 4. ViewModel은 응답 받은 데이터를 가공해서 저장 합니다.
> 5. View는 ViewModel과의 Data Binding으로 인해 자동으로 갱신 됩니다.

## Model
앱의 비즈니스 로직과 데이터를 관장하는 영역

## View
유저에게 데이터를 보여주거나, UI를 담당하는 영역

View Controller를 포함

> View는 '어떻게' 보여질 지에 대해서만 관장하고, '어떤 것'을 보여줄 지에 대해서는 알지 못함

## MVVM패턴의 장점
* 뷰와 모델이 완전히 독립적
* 코드의 재사용성
* 간결해진 ViewController 코드
* 유지보수 용이
* Unit Test 용이




