enum CalculatorType {
    case integer(Int), plus, minus, eof
}

struct Token {
    let type: CalculatorType
}

func isDigit(_ c: Character) -> Bool {
    return Int(String(c)) != nil
}

func isAddition(_ c: Character) -> Bool {
    return c == "+"
}

func isWhiteSpace(_ c: Character) -> Bool {
    return c == " "
}

func interpreter(_ text: [Character]) -> Stream<Token> {
    guard let value = text.first else {
        return Stream(Token(type: .eof), nil)
    }
    
    guard !isWhiteSpace(value) else {
        return interpreter(Array(text.dropFirst()))
    }
    
    guard value.isNumber else {
        return isAddition(value)
        ? Stream(Token(type: .plus), { interpreter(Array(text.dropFirst())) })
        : Stream(Token(type: .minus), { interpreter(Array(text.dropFirst())) })
    }
    
    guard let integer = Int(String(value)) else {
        return Stream(Token(type: .eof), nil)
    }
    
    return Stream(Token(type: .integer(integer)), { interpreter(Array(text.dropFirst())) })
}

public func evaluate(_ text: String) -> Int {
    let values = Array(text)
    let stream = interpreter(values)
    var count = 3
    
    func iter(_ stream: Stream<Token>?, _ currentValue: Int = 0) -> Int {
        guard let stream = stream else {
            return 0
        }

        switch stream.value.type {
        case .eof:
            return currentValue
        case .plus:
            return currentValue + iter(stream.next)
        case .minus:
            return currentValue - iter(stream.next)
        case .integer(let i):
            return iter(stream.next, Int(String(currentValue) + String(i)) ?? 0)
        }
    }
    
    return iter(stream)
}

