

var greeting = "Hello, playground"

/*
 Array
 */
var a = Array<String>()
var b = [String]()

let bigNumbers = [2, 47, 118, 5, 9].filter({ $0 > 20 }) // [47, 118]
print(bigNumbers)
let stringfiled: [String] = [1, 2, 3].map { String($0) } // Int -> String
print(stringfiled)
let sum: Int = [1, 2, 3].reduce(0) { $0 + $1 } // 6
print(sum)

/*
 Dictionary
 */
var c = Dictionary<String, Int>()
var d = [String: Int]()

/*
 String
 */



/*
 Other Classes
 
 - NSObject
 ObjectiveC로 된 API에 접근하려면 필요
 
 - NSNumber
 
 - NSDate
 UI에 날짜를 넣을 때 필요
 
 -NSData
 bag o'bits
 */
