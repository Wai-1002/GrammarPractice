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
//let greeting: (String) -> String
//do {
//    let symbol = "!"
//    greeting = { user in
//        return "Hello, \(user)\(symbol)"
//    }
//}
//greeting("Ishikawa")

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
//struct Greeting {
//    static let signature = "Sent from iPhone"
//
//    var to = "Yosuke Ishikawa"
//    var body = "Hello"
//}
//
//func print(greeting: Greeting) {
//    print("to \(greeting.to)")
//    print("body: \(greeting.body)")
//    print("signature: \(Greeting.signature)")
//}
//
//let greeting1 = Greeting()
//var greeting2 = Greeting()
//greeting2.to = "Yusei Nishiyama"
//greeting2.body = "Hi!"
//print(greeting: greeting1)
//print("--")
//print(greeting: greeting2)

//プロパティオブザーバ
struct Greeting3 {
    var to = "Yousuke Ishikawa" {
        willSet {
            print("willSet: (to: \(self.to), newValue: \(newValue)")
        }
        
        didSet {
            print("didset: (to: \(self.to))")
        }
    }
}

//var greeting = Greeting3()
//greeting.to = "Yusei Nishiyama"

//レイジーストアドプロパティ
//アクセスされるまで初期化を遅延させることができる

//イニシャライザ
struct Greeting {
    let to: String
    var body: String {
        return "Hello, \(to)!"
    }
    
    init(to: String) {
        self.to = to//左のtoは let to:String のtoで右のtoはinit(to:String)のto　宣言時に値を入れなければならない
    }
}

let greeting = Greeting(to: "Yosuke Ishikawa")
let body = greeting.body

//サブスクリプト　コレクション要素へのアクセス
struct Progression {
    var numbers: [Int]
    
    subscript(index: Int) -> Int {
        get {
            return numbers[index]
        }
        
        set {
            numbers[index] = newValue
        }
    }
}

var progression = Progression(numbers: [1, 2, 3])
let element1 = progression[1]

progression[1] = 4
let element2 = progression[1]

//エクステンション
extension String {
    var enclosedString: String {
        return "[\(self)]"
    }
}

let title = "重要".enclosedString + "今日は休み"

//型のネスト

struct NewsFeedItem {
    enum Kind {
        case a
        case b
        case c
    }
    
    let id: Int
    let title: String
    let kind: Kind
    
    init(id: Int, title: String, kind: Kind) {
        self.id = id
        self.title = title
        self.kind = kind
    }
}

let kind = NewsFeedItem.Kind.a
let item = NewsFeedItem(id: 1, title: "Table", kind: kind)
switch item.kind {
case .a: print("kind is .a")
case .b: print("kind is .b")
case .c: print("kind is .c")
}

//値型
struct Color2 {
    var red: Int
    var green: Int
    var blue: Int
}

var a = Color2(red: 255, green: 0, blue: 0)
var b = a
a.red = 0

a.red
a.green
a.blue

b.red
b.green
b.blue

//参照型
class IntBox {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}

var c = IntBox(value: 1)
var d = c

c.value = 2

c.value
d.value

//メンバーワイズイニシャライザ
struct Article {
    var id: Int
    var title: String
    var body: String
    
    //以下と同様のイニシャライザが自動的に定義される
//    init(id: Int, title: String, body: String) {
//        self.id = id
//        self.title = title
//        self.body = body
//    }
}

let article = Article(id: 1, title: "Hello", body: "...")
article.id
article.title
article.body

//プロトコル連想型
protocol RandomValueGenerator {
    associatedtype Value
    
    func randomValue() -> Value
}

struct IntegerRandomValueGenerator : RandomValueGenerator {
    func randomValue() -> Int {
        return Int.random(in: Int.min...Int.max)
    }
}

struct StringandomValueGenerater : RandomValueGenerator {
    func randomValue() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let offset = Int.random(in: 0..<letters.count)
        let index = letters.index(letters.startIndex, offsetBy: offset)
        return String(letters[index])
    }
}

//プロトコルエクステンションとデフォルト実装
protocol Item {
    var name: String { get }
    var caution: String? { get }
}

extension Item {
    var caution: String? {
        return nil
    }
    
    var description: String {
        var description = "商品名: \(name)"
        if let caution = caution {
            description += "、　注意事項: \(caution)"
        }
        return description
    }
}

struct Book : Item {
    let name: String
}

struct Fish : Item {
    let name: String
    
    var caution: String? {
        return "クール便での発送となります"
    }
}


let book = Book(name: "Swift実践入門")
print(book.description)

let fish = Fish(name: "秋刀魚")
print(fish.description)
