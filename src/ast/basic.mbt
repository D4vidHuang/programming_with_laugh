///|
pub typealias String as Ident

///|
pub(all) struct ConstrIdent(Ident) derive(Eq, Hash)

///|
pub(all) struct TypeIdent(Ident) derive(Eq, Hash)

///|
pub(all) enum Op1 {
  Neg
  Not
} derive(ToJson(style="flat"))

///|
pub(all) enum Op2 {
  Add
  Sub
  Mul
  Div
  Mod
  Eq
  Neq
  Ge
  Geq
  Le
  Leq
} derive(ToJson(style="flat"))

///|
pub(all) enum Lit {
  Unit
  Bool(Bool)
  Int(Int)
  Double(Double)
}
