# NetworkExtensions

This package adds some Extensions for making network (HTTP) requests with the Foundation framework.

## Base URL

A default base URL can be set via the `static` property in the `URLRequest` struct:

```swift
URLRequest.baseURL = "https://api.server.com/"

let request = try URLRequest() // Uses the default base URL   
```

### Endpoint

We can add endpoints as `String`:

```swift
let request = try URLRequest(endpoint: "users") // Uses the default base URL with the users endpoint
```

We can also add endpoints using the `Endpoint` protocol:

```swift
enum AuthAPI: Endpoint {
	case login
	case register
 
	var method: HTTPMethod {
		.post
	}

	var path: String {
		switch self {
		case .login: return "login"
		case .register: return "register"
		}
	}
}
let request = try URLRequest(endpoint: AuthAPI.login)
```

## Request Operations

There are many operations that can be chained in order to build a full request (see full example at the end). Let's see all the available operations:

### Method

By default, the HTTP method (verb) for new requests is GET, but it can be changed like this:

```swift
let request1 = try URLRequest()
	.method(.post) // The new method is POST
let request2 = try URLRequest()
	.method("delete") // The new method is DELETE
```

### Headers

To add custom headers to the request, there is a simple way now:

```swift
let request1 = try URLRequest()
	. headers([
		"Header1": "Value1",
		"Header2": 10
	])
let request2 = try URLRequest()
	.header(name: "Header", value: 99)
```

There is a special method to set the `Authorization` token (the default scheme is `Bearer`):

```swift
let request3 = try URLRequest()
	.authorization(token: "abcde")
let request4 = try URLRequest()
	.authorization(scheme: "Basic", token: "abcde")
```

### Query Items

If you want to add query items to the URL (i.e.: "https://api.server.com/endpoint?query=10"), it can be done this way:


```swift
let request1 = try URLRequest()
	.queryItem(name: "query", value: 10)
let request2 = try URLRequest()
	.queryItems([
		"field1": "value",
		"field2": 15
	])
let request3 = try URLRequest()
	.queryItems(encodableObject)
```

### JSON Body

In order to send requests with a JSON body, we can use these methods with encodable objects or dictionaries:

```swift
let request1 = try URLRequest()
	.json([
		"field1": "value",
		"field2": 15
	])
let request2 = try URLRequest()
	.json(encodableObject)
```

### Form-Data Body

Finally, we can send form-data requests with some special parameters:

```swift
let request = try URLRequest()
	.formData([
		TextFormDataParameter(name: "name", value: "John"),
		FileFormDataParameter(
			name: "image",
			filename: "image.jpg",
			contentType: "image/jpg",
			data: imageData
		),
		JSONFormDataParameter(name: "person", object: Person(age: 30))
	])
```

### When (Otherwise)

This is a special operator that can execute a block according to a condition, just like an `if` or `if/else` statement:

```swift
let request1 = try URLRequest()
	.when(condition1) { request in
		request.method(.post)
	}

let request2 = URLRequest()
	.when(condition2) { request in
		var request = request
		request.httpMethod = "POST"
		return request
	} otherwise: { request in
		request.method(.delete)
	}
```

## Sending the Request

Currently, there are two ways to do it, with the completion handler and with the async/await method. Both can have a specific session, otherwise they will use the `URLSession.shared` session.

### Completion Handler

It is possible to create a Data Task and auto resume it with a closure as the completion handler:

```swift
let task1 = try request.dataTask(on: session) { data, response, error in
	doSomething()
}
let task2 = try request.dataTask(autoResume: false) { data, response, error in
	doSomething()
}
task2.resume()
```

### Async/Await

There is also support to use the `async/await` feature:

```swift
let (data1, response1) = try await request.send()
let (data2, response2) = try await request.send(on: session)
```

## Handling Responses

Last but not least, we have added a few extensions in order to help handling the responses from the servers such as the `httpStatusCode` enum, the `response.headers` dictionary and all the conversions from `Data`.

```swift
let (data, response) = try await request.send()

guard response.httpStatusCode == .ok else { return }

if let token = response.headers?["token"] {
	save(token: token)
}

let intValue = data.intValue
let floatValue = data.floatValue
let doubleValue = data.doubleValue
let arrayValue = data.arrayValue as? [Int]
let dictionaryValue = data as? [String: Int]
let stringValue = data.stringValue()
let string16Value = data.stringValue(encoding: .utf16)
let person: Person? = data.jsonObject()
```

## Usage

Let's see a full example of how to send a request and get the response:

```swift
enum CustomError: Error {
	case invalidRequest
	case invalidResponse
}

struct Credentials: Codable {
	let email: String
	let password: String
}

struct User: Codable {
	let id: Int
	let name: String
	let age: Int
}

enum AuthAPI: Endpoint {
	case login
	case register
	var path: String {
		switch self {
		case .login: return "Login"
		case .register: return "Register"			}
	}
}

func login(credentials: Credentials) async throws -> User {
	let (data, response) = try await URLRequest(endpoint: AuthAPI.login)
		.method(.post)
		.json(credentials)
		.send()
	guard response.httpStatusCode == .ok else {
		throw CustomError.invalidRequest
	}
	guard let user: User = data.jsonObject() else {
		throw CustomError.invalidResponse
	}
	return user
}
```
