# NetworkExtensions

This package adds some Extensions for making network (HTTP) requests with the Foundation framework.

## Request Operations

There are many operations that can be chained in order to build a full request (see full example at the end). Let's see all the available operations:

### Init with String URL

There is a way to create requests using a `String` url:

```swift
let request = try URLRequest(stringUrl: "https://api.server.com")
```

### Method

By default, the HTTP method (verb) for new requests is GET, but it can be changed like this:

```swift
let request = try URLRequest(stringUrl: "https://api.server.com")
	.method("post") // The new method is POST
	.method("delete") // The new method is DELETE
```

### Headers

To add custom headers to the request, there is a simple way now:

```swift
let request = try URLRequest(stringUrl: "https://api.server.com")
	.header(name: "Header", value: 99)
	.headers([
		"Header1": "Value1",
		"Header2": 10
	])
```

There is a special method to set the `Authorization` token (the default scheme is `Bearer`):

```swift
let request = try URLRequest(stringUrl: "https://api.server.com")
	.authorization(token: "abcde")
	.authorization(scheme: "Basic", token: "abcde")
```

### Query Items

If you want to add query items to the URL (i.e.: "https://api.server.com/endpoint?query=10"), it can be done this way:


```swift
let request = try URLRequest(stringUrl: "https://api.server.com")
	.queryItem(name: "query", value: 10)
	.queryItems([
		"field1": "value",
		"field2": 15
	])
	.queryItems(encodableObject)
```

### JSON Body

In order to send requests with a JSON body, we can use these methods with encodable objects or dictionaries:

```swift
let request = try URLRequest(stringUrl: "https://api.server.com")
	.json([
		"field1": "value",
		"field2": 15
	])
	.json(encodableObject)
```

### Form-Data Body

Finally, we can send form-data requests with some special parameters:

```swift
let request = try URLRequest(stringUrl: "https://api.server.com")
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
let request = try URLRequest(stringUrl: "https://api.server.com")
	.when(condition1) { request in
		request.method(.post)
	}
	.when(condition2) { request in
		var request = request
		request.httpMethod = "PUT"
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
	static var baseUrl = "https://api.server.com/"
	case login
	case register
	var path: String {
		switch self {
		case .login: return baseUrl + "Login"
		case .register: return baseUrl + "Register"
		}
	}
}

func login(credentials: Credentials) async throws -> User {
	let (data, response) = try await URLRequest(stringUrl: AuthAPI.login.path)
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
