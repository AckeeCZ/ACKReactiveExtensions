# Argo extensions

ACKReactiveExtensions contain extensions that allow you to simply call correct Argo mapping function. Extensions are written for `Signal`s and `SignalProducer`s based on their value and error type.

You can use default `DecodeError` from [Argo](https://github.com/thoughtbot/Argo) which is supported out of box or any custom error you like. Your error just needs to conform to `DecodeErrorCreatable` protocol because in case of a mapping failure we need to be capable of creating your error with appropriate message.

## Sample usage

We generally assume that you have a `Signal` or `SignalProducer` which produces your data and we were like _Okay and how we can get rid of all that boring boilerplate code that takes our dictionary/array and converts them into my model objects_. Out solution is extension which wraps all that stuff into single generic method call.

API calls can return a big variety of errors so the `DecodeError` might be a problem and this is where our custom error protocol comes to rescue. You can use any Swift structure as your error type, all you have to do is conform `DecodeErrorCreatable` protocol because we like to inform you in case that something goes wrong with tha mapping. We like using enums for our error types so I'm gonna use it in this example.

```swift
enum MyError: Error {
    case request
    case mapping(DecodeError)
}
```

I need to conform it to `DecodeErrorCreatable`:

```swift
extension MyError: DecodeErrorCreatable {
    func createDecodeError(_ decodeError: DecodeError) -> MyError {
        return .mapping(decodeError)
    }
}
```

That was simple right?

You also need some model object so you have something you can map to right:

```swift
struct Car {
    let manufacturer: String
    let model: String
}
```

Now in your API calls you just call `mapResponse()` method and you get what you want.

```swift
func fetchCars() -> SignalProducer<[Car], MyError> {
    let apiCall: SignalProducer<Any, MyError> = ... // make your api call
    return apiCall.mapResponse()
}
```

That's nicer than using various `map`s and `flatMap`s in your every single call, isn't it?

## Advanced usage

### Use root key

In case your data aren't always root objects of your API response you can use `rootKey` parameter of `mapResponse()` method.

```swift
func fetchCars() -> SignalProducer<[Car], MyError> {
    let apiCall: SignalProducer<Any, MyError> = ... // make your api call
    return apiCall.mapResponse(rootKey: "data")
}
```

### Object transformations and ambiguity

In some cases you might need to perform some other transformations with you objects. This might occasionally become little tricky because the compiler needs to know which object should be mapped. In the previous sample the final type of expression was determined by the return type of `fetchCars()` function, but in some cases it isn't as straightforward.

Just assume the you are just interested in fetching just manufacturers of all cars:
```swift
func fetchManufacturers() -> SignalProducer<[String], MyError> {
    let apiCall: SignalProducer<Any, MyError> = ... // make your api call just like you did before
    return apiCall
        .mapResponse() // ambiguous use of mapResponse()
        .map { $0.map { $0.manufacturer } }
}
```

Now you end up with ambiguity. How so? It's simple, now the compiler doesn't know that you want to map `[Car]` and the solution is simple, you just tell him:

```swift
func fetchManufacturers() -> SignalProducer<[String], MyError> {
    let apiCall: SignalProducer<Any, MyError> = ... // make your api call just like you did before
    return apiCall
        .mapResponse()
        .map { (cars: [Car]) in
            return cars.map { $0.manufacturer }
        }
}
```

Now you're all set and ready. The same issue arises if you don't return you `SignalProducer` directly but save him into local variable. The solution is the same:
```swift
func fetchCars() -> SignalProducer<[Car], MyError> {
    let apiCall: SignalProducer<Any, MyError> = ... // make your api call
    let carsProducer: SignalProducer<[Car], MyError> = apiCall.mapResponse()
    return carsProducer
}
```
