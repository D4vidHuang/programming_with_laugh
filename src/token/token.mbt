///|
pub enum TokenType {
  /// [a-zA-Z_][a-zA-Z0-9_]*;
  Id
  /// [A-Z][a-zA-Z0-9_]*
  UpId
  /// [0-9]+
  Number
  /// cmp: == != >= <= < >
  /// 
  /// op: && || . + - * / % =
  ///
  /// par: ( ) [ ] { }
  ///
  /// other: -> : ; , ::
  Symbol
  /// space: [ \t\r\n]
  /// comment: '//' ~[\r\n]* 
  /// Skip
} derive(Show, ToJson(style="flat"))

///|
typealias @bytes.View

///|
pub suberror TokenError View

///|
pub impl Show for TokenError with output(self, logger) {
  let TokenError(view) = self
  logger.write_string("token error at offset: \{view.start_offset()}")
}

///|
fn is_symbol_1(c1 : Byte) -> Bool {
  c1 is ('>' | '<') ||
  c1 is ('.' | '+' | '-' | '*' | '/' | '%' | '=') ||
  c1 is ('(' | ')' | '[' | ']' | '{' | '}') ||
  c1 is (':' | ';' | ',')
}

///|
fn is_symbol_2(c1 : Byte, c2 : Byte) -> Bool {
  ([c1, c2] : Bytes) is ("==" | "!=" | ">=" | "<=" | "&&" | "||" | "->" | "::")
}

///|
fn for_ident(rest : View) -> (Bytes, View) {
  let b = @buffer.new()
  let rest = loop rest {
    ['a'..='z' | 'A'..='Z' | '0'..='9' | '_' as c, .. rest] => {
      b.write_byte(c)
      continue rest
    }
    rest => break rest
  }
  (b.to_bytes(), rest)
}

///|
fn for_number(rest : View) -> (Bytes, View) {
  let b = @buffer.new()
  let rest = loop rest {
    ['0'..='9' as c, .. rest] => {
      b.write_byte(c)
      continue rest
    }
    rest => break rest
  }
  (b.to_bytes(), rest)
}

///|
pub fn tokenize(code : View) -> Array[(TokenType, Bytes)] raise TokenError {
  let res = []
  let rest = code
  loop rest {
    [' ' | '\t' | '\r' | '\n', .. rest] => continue rest
    [.. "//", .. rest] =>
      continue loop rest {
          ['\n' | '\r', .. rest] => break rest
          [_, .. rest] => continue rest
          [] => break []
        }
    ['a'..='z' | '_', ..] as rest => {
      let (ident, rest) = for_ident(rest)
      res.push((Id, ident))
      continue rest
    }
    ['A'..='Z', ..] as rest => {
      let (ident, rest) = for_ident(rest)
      res.push((UpId, ident))
      continue rest
    }
    ['0'..='9', ..] as rest => {
      let (number, rest) = for_number(rest)
      res.push((Number, number))
      continue rest
    }
    [c1, c2, .. rest] if is_symbol_2(c1, c2) => {
      res.push((Symbol, [c1, c2]))
      continue rest
    }
    [c1, .. rest] if is_symbol_1(c1) => {
      res.push((Symbol, [c1]))
      continue rest
    }
    [] => ()
    rest => raise TokenError(rest)
  }
  res
}
