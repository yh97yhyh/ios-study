import UIKit

var greeting = "Hello, playground"

/*
 Properties
 
 Observer
 - set될 때마다 호출
 - willSete : set 전에
 - didSet : set 뒤에
 - 값 타입을 바꿀 때도 호출
 - UI를 업데이트 할때 많이 쓰임

 

 Lazy
 - var가 늦게 초기화 되도록
 */


var someStoredProperty: Int = 42 {
    willSet { } // newValue
    didSet { } // oldValue
}

