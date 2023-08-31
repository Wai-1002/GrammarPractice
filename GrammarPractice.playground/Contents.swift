//5.4　遅延実行
var count = 0

func someFunction() -> Int {
    defer {
        count += 1
    }
    return count
}

someFunction()
count
//ラベル
label: for element in [1, 2, 3] {
    for nestedElement in [1, 2, 3] {
        print("element: \(element), nestedElement: \(nestedElement)")
        break label
    }
}

//5.5パターンマッチ　オプショナルパターンとバリューバインディングパターン
let optionalA = Optional(4)
switch optionalA {
case let a?:
    print(a)
default:
    print("nil")
}

//列挙型パターン
enum Color {
    case rgb(Int, Int, Int)
    case cmyk(Int, Int, Int, Int)
}

let color = Color.rgb(100, 200, 255)

switch color {
case .rgb(let r, let g, let b):
    print(".rgb:(\(r), \(g), \(b)")
    
case .cmyk(let c, let m, let y, let k):
    print(".cmyk: (\(c), \(m), \(y), \(k)")
}

//guard文(マッチしないと実行)
func someFunction2() {
    let value = 9
    guard case 1...10 = value else {
        return
    }
    
    print("1以上10以下の値です")
}

someFunction2()

//for in文のパターンマッチ caseを使う
let array = [1, 2, 3, 4]

for case 2...3 in array {
    print("2以上3以下の値です")
}

//_の使い方 f3 == f4
func f3(value: Int) {
}
f3(value: 1)

func f4(_ value: Int) {
}
f4(1)

//デフォルト引数
func search(byQuery query: String, sortKey: String = "id", ascending: Bool = false) -> [Int] {
    return [1, 2, 3]
}

search(byQuery: "query")

//インアウト引数
func greet(user: inout String) {
    if user.isEmpty {
        user = "Anonymous"
    }
    print("Hello, \(user)")
}
var user: String = ""
greet(user: &user)

//可変長引数

func print(strings: String...) {
    if strings.count == 0 {
        return
    }
    
    print("first: \(strings[0])")
    
    for string in strings {
        print("element: \(string)")
    }
}

print(strings: "abc", "def", "ghi")

//クロージャ
//
var closure: (String) -> Int
//
//closure = { (string: String) -> Int in
//    return string.count
//}
//closure("abc")
//↓省略形
closure = { string in
    return string.count * 2
}
closure("abc")

//キャプチャ　クロージャが自身が定義されたスコープの変数や定数への参照を保持している
let greeting: (String) -> String
do {
    let symbol = "!"
    greeting = { user in
        return "Hello, \(user)\(symbol)"
    }
}
greeting("Ishikawa")

//escaping属性
var queue = [() -> Void]()

func enqueue(operation: @escaping () -> Void) {
    queue.append(operation)
}

enqueue {
    print("executed")
}
enqueue {
    print("executed")
}

queue.forEach{ $0() }

//クロージャ式を利用した変数や定数の初期化
var board: [[Int]] = {
    let sideLength = 3
    let row = Array(repeating: 1, count: sideLength)
    let board = Array(repeating: row, count: sideLength)
    return board
}()

board

//スタティックプロパティ --型自身に紐づくプロパティ
