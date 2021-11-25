import UIKit

var greeting = "Hello, playground"


/*
 Tuples
 Function에서 여러 개의 값을 return 할 수 있음
 */

let x: (String, Int, Double) = ("hello", 5, 0.85)
let (word, number, value) = x
print(word)
print(number)
print(value)

let x1: (w: String, i: Int, v: Double) = ("hello", 5, 0.85)
print(x1.w)
print(x1.i)
print(x1.v)
