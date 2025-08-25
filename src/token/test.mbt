///|
/// 把 tokenize 的结果转化为字符串，每一项用竖线 "|" 分开
fn helper(code : String) -> String raise TokenError {
  let code = code.iter().map(x => x.to_int().to_byte()) |> Bytes::from_iter
  let b = StringBuilder::new()
  let tokens = tokenize(code)
  for i, t in tokens {
    let (token_type, token) = t
    b..write_object(token_type)..write_string(" ")
    for byte in token {
      b.write_char(byte.to_char())
    }
    if i > 0 && i % 5 == 0 {
      b.write_string(" |\n")
    } else {
      b.write_string(" | ")
    }
  }
  b.to_string()
}

///|
test "while loop" {
  let code =
    #|{
    #|  let a = Array::make(10, 3)
    #|  let mut i   = 0    // index
    #|  let mut sum = 0    // sum
    #|  while i < length(a) {
    #|    sum = sum + i
    #|  }
    #|  sum
    #|}
  inspect(
    helper(code),
    content=(
      #|Symbol { | Id let | Id a | Symbol = | UpId Array | Symbol :: |
      #|Id make | Symbol ( | Number 10 | Symbol , | Number 3 |
      #|Symbol ) | Id let | Id mut | Id i | Symbol = |
      #|Number 0 | Id let | Id mut | Id sum | Symbol = |
      #|Number 0 | Id while | Id i | Symbol < | Id length |
      #|Symbol ( | Id a | Symbol ) | Symbol { | Id sum |
      #|Symbol = | Id sum | Symbol + | Id i | Symbol } |
      #|Id sum | Symbol } | 
    ),
  )
}

///|
test "fact" {
  let code =
    #|fn fact(n : Int) -> Int {
    #|  if n == 0 {
    #|    1
    #|  } else {
    #|    n * fact(n - 1)
    #|  }
    #|}
    #|
  inspect(
    helper(code),
    content=(
      #|Id fn | Id fact | Symbol ( | Id n | Symbol : | UpId Int |
      #|Symbol ) | Symbol -> | UpId Int | Symbol { | Id if |
      #|Id n | Symbol == | Number 0 | Symbol { | Number 1 |
      #|Symbol } | Id else | Symbol { | Id n | Symbol * |
      #|Id fact | Symbol ( | Id n | Symbol - | Number 1 |
      #|Symbol ) | Symbol } | Symbol } | 
    ),
  )
}

///|
test "not support" {
  let code = "1 ^ 2"
  inspect(try? helper(code), content="Err(token error at offset: 2)")
}
