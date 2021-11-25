import UIKit

var greeting = "Hello, playground"

/*
 Methods
 
 - internal name
 - external name : 호출하는 사람이 사용'
 
 - final : overriding 불가

 */

func foo(externalFirst first: Int, externalSecond second: Int) -> Int {
    return first + second
}

let result = foo(externalFirst: 123, externalSecond: 3)

func foo2(_ first: Int, _ second: Int) -> Int {
    return first + second
}

let result2 = foo2(123, 4)
