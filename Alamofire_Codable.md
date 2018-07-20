# 8. Alamofire / Codable

## [Alamofire](https://github.com/Alamofire/Alamofire)
Swift 에서 HTTP 네트워킹을 위한 대표적인 오픈소스 라이브러리 이다.  
  
* Request 와 Response 가 연계되는 함수제공
* URL / JSON 형태 파라미터 인코딩
* File / Data / Stream / MultipartFormData 업로드 기능
* HTTP Response 의 Validation

### Request
서버에 요청을 보내기 위해 제공되는 함수  
  
`Alamofire.request` 에 다양한 argument 가 존재한다.  
  
#### 기본 사용법
  ```swift
  Alamofire.request("http://myurl.com")
  ```
#### HTTP Methods - `method`
  ```swift
  public enum HTTPMethod: String {
	  case options = "OPTIONS"
	  case get     = "GET"
	  case head    = "HEAD"
	  case post    = "POST"
	  case put     = "PUT"
	  case patch   = "PATCH"
	  case delete  = "DELETE"
	  case trace   = "TRACE"
	  case connect = "CONNECT"
  }
  ```
  > HTTPMethod enum 이 `Alamofire`에  정의되어있다.  
  대표적으로 REST API 에서 쓰이는 get, post, put, delete 를 인자로 전달할 수 있다.
  ```swift
  Alamofire.request("https://myurl.com/get")
  Alamofire.request("https://myurl.com/post", method: .post)
  Alamofire.request("https://myurl.com/put", method: .put)
  Alamofire.request("https://myurl.com/delete", method: .delete)
  ```
  > `method` 파라미터의 default 값은 `.get`
 
#### Paramether Encoding - `parameters`, `encoding`   
  > * Alamofire는 URL, JSON, PropertyList 등 3가지 매개 변수 인코딩 유형을 지원한다.  
  > * `ParameterEncoding` protocel을 준수하는 범위에서 custom encoding을 지원한다.  
  > * 아래에서는 `JSONEncoding`만 소개함  
* **JSONEncoding**
  > `JSONEncoding` 타입은 `parameters` 객체를 JSON 표현으로 인코딩  
  > HTTP Header의 `Content-Type` 이  `application/json` 으로 설정
  ```swift
  let parameters = [
	  "name": "iOS",
	  "age": 26
  ]
  // 아래 두가지 방법 동일
  Alamofire.request("https://myurl.com/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)
  Alamofire.request("https://myurl.com/post", method: .post, parameters: parameters, encoding: JSONEncoding(options: []))
  
  // HTTP body: {"name": "iOS", "age": 24}
  ```
 
#### HTTP Headers - `headers`
  > HTTPHeaders 타입의 헤더를 설정할 수 있다.
  ```swift
  let headers: HTTPHeaders = [
	  "Authorization": "QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
	  "Accept": "application/json"
  ]
  
  Alamofire.request("https://myurl.com/headers", headers: headers).responseJSON { response in
	  print(response)
  }
  ```
  > 변경되지 않는 HTTP 헤더는 `URLSessionConfiguration`에 설정하여 기본 `URLSession`에서 만든 `URLSessionTask`에 자동으로 적용하는 것이 좋다.  
  > 자세한 내용은 [Session Manager Configurations](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#session-manager) 참조

### Response Handling
`Alamofire.request`에 연결하여 reponse handling이 가능하다.  
  
다양한 response handler가 제공된다.  
  ```swift
  Alamofire.request("https://myurl.com/get").responseJSON { response in
	  print("Request: \(String(describing: response.request))")   // original url request
	  print("Response: \(String(describing: response.response))") // http url response
	  print("Result: \(response.result)")                         // response serialization result
  }
  ```
  > request에 대한 response가 수신된 후 response를 처리하기 위해 `closure`형식의 콜백이 지정됨  
  > response 에 정의된 `closure` 안에서 수신된 응답에 대한 처리를 수행한다.  
  > Alamofire의 네트워킹은 비동기로 처리된다.  
  
  Alamofire 에는 다섯가지의 response handler를 제공한다.
  ```swift
// Response Handler - Unserialized Response
func response(
    queue: DispatchQueue?,
    completionHandler: @escaping (DefaultDataResponse) -> Void)
    -> Self

// Response Data Handler - Serialized into Data
func responseData(
    queue: DispatchQueue?,
    completionHandler: @escaping (DataResponse<Data>) -> Void)
    -> Self

// Response String Handler - Serialized into String
func responseString(
    queue: DispatchQueue?,
    encoding: String.Encoding?,
    completionHandler: @escaping (DataResponse<String>) -> Void)
    -> Self

// Response JSON Handler - Serialized into Any
func responseJSON(
    queue: DispatchQueue?,
    completionHandler: @escaping (DataResponse<Any>) -> Void)
    -> Self

// Response PropertyList (plist) Handler - Serialized into Any
func responsePropertyList(
    queue: DispatchQueue?,
    completionHandler: @escaping (DataResponse<Any>) -> Void))
    -> Self

  ```
  
#### Response Data Handler
  > `responseData` handler 는 서버에서 받아온 `Data`를 `responseDataSerializer`에 추출한다.  
  > 수신된 `Data`에 에러가 없다면 response의 `Result`에는 `.success`, `Data` 타입의 `value`가 set 된다.
  ```swift
  Alamofire.request("https://myurl.com/get").responseData { response in
    print("All Response Info: \(response)")

    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
    	print("Data: \(utf8Text)")
    }
  }
  ```
### Response Validation
기본적으로 Alamofire는 response 내용과 상관없이 정상적으로 수행된 request는 모두 `.success`로 처리한다.  
  
`validation` 은 허용되지 않는 status code나 [MIME Type](https://developer.mozilla.org/ko/docs/Web/HTTP/Basics_of_HTTP/MIME_types)에 대하여 에러를 검출 할 수 있다.  

#### Manual Validation
```swift
Alamofire.request("https://myurl.com/get")
    .validate(statusCode: 200..<300)
    .validate(contentType: ["application/json"])
    .responseData { response in
        switch response.result {
        case .success:
            print("Validation Successful")
        case .failure(let error):
            print(error)
        }
    }
```

#### Automatic Validation
`validation()` 은 자동적으로 status code `200..<300` 범위와, request의 헤더와 일치하는 `Content-Type` 에 대해 유효성을 부여한다.  

```swift
Alamofire.request("https://myurl.com/get").validate().responseData { response in
    switch response.result {
    case .success:
        print("Validation Successful")
    case .failure(let error):
        print(error)
    }
}
```
  
  
  
## Codable
`Swift 4` 에서 새롭게 추가된 [Protocol](https://github.com/OhKanghoon/SwiftStudy/blob/master/POP.md#%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9Cprotocol).
```swift
typealias Codable = Decodable & Encodable
```
  
### 정의
> A type that can convert itself into and out of an external representation.  
> 자신을 변환하거나 외부표현으로 변환할 수 있는 타입  
> Decodable : 자신을 외부표현(external representation)에서 디코딩 할 수 있는 타입  
> Encodable : 자신을 외부표현(external representation)으로 인코딩 할 수 있는 타입  
> 외부표현은 JSON 이라고 생각하면 됨  

### Usage
> `protocol` 이므로  `class`, `struct`, `enum` 에서 사용가능하다.  
  
  
```json
{
    "name" : "iOS",
    "age" : 26
}
```  
이러한 JSON 데이터를  

```swift
struct Person : Codable {
    var name : String
    var age : Int
}
```
이 struct에 변환 가능하다.
  
따라서 JSON 데이터로부터 Person 타입인 값을 얻을 수 있다.
```swift
let personData = """
{
    "name" : "iOS",
    "age" : 26
}
""".data(using: .utf8)!

let person = try! JSONDecoder().decode(Person.self, from: personData)
print(person) // Person(name: "iOS", age: 26)
```
  
JSON 데이터의 key값이 Codable 의 key와 1:1로 매칭된다면 자동으로 변환가능하다.

#### Encoding
> Person -> JSON
```swift
let encoder = JSONEncoder()
let person = Person(name: "iOS", age: 26)
let jsonData = try? encoder.encode(person)

if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
	print(jsonString) // {"name":"iOS","age":26}
}
```
  
> JSON으로 변환할때 encoder에 `.outputFormatting` 옵션을 줄 수 있다.
```swift
encoder.outputFormatting = .sortedKeys // key값으로 JSON 데이터를 정렬
encoder.outputFormatting = .prettyPrinted
// {
//    "name" : "iOS",
//    "age" : 26
// }

encoder.outputFormatting = [.sortedKeys, .prettyPrinted] // 두개 동시에 가능
```

#### Decoding
> JSON -> Person
```swift
let decoder = JSONDecoder()
var data = jsonString.data(using: .utf8)
if let data = data, let myPerson = try? decoder.decode(Person.self, from: data) {
    print(myPerson.name) // iOS
    print(myPerson.age) // 26
}
```

#### CodingKeys
> 만약 JSON의 key 와 다른 이름으로 지정하고 싶다면 `CodingKeys`를 설정해주어야 한다.
```swift
struct Person: Codable {
    var myName: String
    var myAge: Int

    enum CodingKeys: String, CodingKey {
        case myName = "name"
        case myAge = "age"
    }
}
```
> Swift 4.1 부터는 snake_case 인 JSON key를 자동으로 camelCase의 key와 매칭가능하다고 한다.
```swift
{
    "my_name" : "iOS",
    "my_age" : 26
}

let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase // 이부분에서 설정
```

#### 특정 key, value가 없는 경우
> Object는 key, value가 존재하거나 존재하지 않을 수 있기 때문에 특정 key가 없이 데이터가 내려올 수 있다.
```swift
* before
{
    "name": "iOS",
    "age": 26
}

* after
{
    "name": "Swift"
}
```
> 위와 같이 이전에 잘 내려오고 있던 데이터가 갑자기 특정 key가 안내려온다면 `keyNotFound` 에러 발생  
  
```swift
struct Person: Codable {
    var myName: String
    var myAge: Int

    enum CodingKeys: String, CodingKey {
        case myName = "name"
        case myAge = "age"
    }

	init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
      	myName = (try? values.decode(String.self, forKey: .myName)) ?? ""
        myAge = (try? values.decode(String.self, forKey: .myAge)) ?? ""
    }
}
```
> 이런식으로 직접 decode를 하고 기본값을 넣어주는 방식으로 해결하거나
```swift
struct Person: Codable {
    var myName: String?
    var myAge: Int?

    enum CodingKeys: String, CodingKey {
        case myName = "name"
        case myAge = "age"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        myName = (try? values.decode(String.self, forKey: .myName))
        myAge = (try? values.decodeIfPresent(String.self, forKey: .myAge))
    }
}
```
> 옵셔널로 선언한다. 이 경우에는 key에대한 value가 null일때에도 동일하다.

## Alamofire & Codable model
Alamofire와 Codable을 이용한 request 사용법

* Model
> `Codable` model 선언
```swift
struct Person: Codable {
	let name: String
	let age: Int

	enum CodingKeys: String, CodingKey {
		case name = "user_name"
		case age = "user_age"
	}
}
```

* Alamofire.request
> request 후 response handler 호출
```swift
func getPersonData(completion: @escaping (Person) -> Void, error: @escaping (String) -> Void) {
    Alamofire.request(URL).responseData { (res) in
        switch res.result {
        case .success:
            if let value = res.result.value {
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(Person.self, from: value)
                    completion(data)
                } catch {
                    error("error")
                }
            }
        case .failure(let err):
            error(err)
        }
    }
}
```

