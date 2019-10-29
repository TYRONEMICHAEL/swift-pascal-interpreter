struct Stream<A> {
    private let _value: A
    private let _next: (() -> Stream<A>?)?

    init(_ value: A, _ next: (() -> Stream<A>?)?) {
        self._value = value
        self._next = next
    }
    
    var value: A {
        return _value
    }

    var next: Stream<A>? {
        return _next?()
    }
}
