

# iPhone X 대응하기 (ios 9 이상에서 ..?)



* **iPhoneX 의 다른점**

  * 3x 용 기기  : 1point는 화면에서 3x3픽셀의 정사각형이다.

    - 그러므로 에셋에서 @3x 를 사용해야함.

  * 화면 크기가 다르다 .

    * 375 X 812 이다 .

  * Aspect ratio(화면 종횡비) 가 다르다 .

    * 6/6s/7/8 는  9:16의 종횡비를 가지고 있지만 iPhoneX는 9:19.5 라는 종횡비를 가지고 있다.

  * 상태바는 상단의 둥근 모서리 부분 사용한다 .(네이게이션 바가 없다면 그곳까지 화면을 보여줄수있다.)

  * 상태바 가 기존 20pt에서 44pt로 더 커졌다.

  * 버튼을 홈 부분 근처에다 두지 마세요.

    



# **여기서 문제점**

* 이전 버전에서의 제작된 앱은 iOS 11에 위의 새로운  화면 크기가 있다는 것을 인식하지 못한다 !

  

  ![6](/images/iphoneX/6.png)

  

  

  위 view 를 보면 ios 10 앱을  ios11 인 X에서 돌린 결과물이다 .

  하단과 상단 status 바의 safe 라인에도 못미치게 짤려서 앱이 구동이된다. 

  

  애플 공식 가이드 문서를 보면 

  ![5](/images/iphoneX/5.png)

  

  ![4](/images/iphoneX/4.png)

  

  



이전 버전의 앱 들은  앞서 말했던 **9:19.5 라는 종종 볼 수도 횡비를 가지고 있어 9:16 이라는 종횡비**를 적용 하기위해 잘려서 나오게 되는 것이다.



**잘리거나, 줄어든 비율의 앱이 빌드 된후의 해결책**

이 대부분의 글들이 safearea에 따라 autolayout을 적용 했다면 문제 없이  적용이 된다고 되어있어  실행해 봤다.



Safearea 를 적용 하지 않고 superview 에  constraints 를 걸 경우



iPhone 8 크기에서는 

![2](/images/iphoneX/2.png)



iPhone X 에서는 

![1](/images/iphoneX/1.png)



이런식으로  superview 에 top,bottom constraints를 붙이면 iPhone 8 의 하단에서만 제대로 보여지게된다 .

당연히 상단은 superview 로 top constraints를 잡으면 상태바를 가리기 때문에  깨져서 나오게 된다.



iPhone X 에서는 상단 뿐만아니라 하단도 신경써야한다. 홈버튼이 없는 대신에 둥근 모서리와 가운데 홈 제스처를 사용하기 때문에 superview가 아닌 safearea에 꼭 맞추어 주어야한다.

![3](/images/iphoneX/3.png)





safeArea 로 맞춘 iPhoneX 대응화면

**한가지더!**

iPhoneX 에서는 상단바와 하단 홈 제스처를 위한 공간 높이가 44로 정해져있다. !(safearea로 constraints를 걸면 자동으로 44 높이에 대응)

그러므로 아래위로 44 의 공간은 앞서 말했듯이 화면을 보여줄수 있되 제스처나 , 버튼 액션 등을 넣지 않는것이 좋다고 한다.

![스크린샷 2018-07-06 오전 7.19.42](/images/iphoneX/9.png)





또한 가로모드나 영화를 볼때 홈 제스처 가 있는곳까지도 데이터를 띄 워 줘야 하는 경우가 있다.

그럴경우 홈 제스처를 위한 Indicator 를 자동적으로 히든 처리되게 하는 함수를 적용 하여 주면된다.

~~~swift

 
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
~~~



마지막으로 iPhoneX 가로 세로 모드의 레이아웃 가이드 이다!

![가로모드 레이아웃가이드](/images/iphoneX/7.jpg)

![10](/images/iphoneX/8.jpg)









코드로 iPhoneX 대응하기

![11](/images/iphoneX/11.png)



```swift
override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
         
            let guide = view.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                btn1.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
                
                ])
            btn1.layer.cornerRadius = 7
            
        }
```

대부분 View 에 관련한 디자인을 ios11.0 일 경우 따로 처리 하여 애플 디자인 가이드에 맞게 처리한다.



참고 사이트 : http://blog.rightbrain.co.kr/?p=8499

​		 https://developer.apple.com/design/human-interface-guidelines/ios/overview/iphone-x/











