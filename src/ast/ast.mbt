///|
pub(all) struct Program {
  top_let : Array[(Ident, TypeIdent, Expr)]
  top_fns : Array[(Ident, Func)]
  main_fn : Func
} derive(ToJson)

///|
pub(all) enum TypeDecl {
  Struct(Array[(Ident, TypeIdent)])
  Enum(Array[(ConstrIdent, Array[TypeIdent])])
} derive(ToJson(style="flat"))

///|
pub(all) struct Func {
  params : Array[(Ident, TypeIdent?)]
  return_type : TypeIdent?
  body : Expr
} derive(ToJson)

///|
pub(all) enum Binding {
  Ident(Ident)
  Wildcard
}

///|
pub(all) enum Expr {
  // Basic
  Lit(Lit)
  Var(Ident)
  // let
  Let(Binding, TypeIdent?, Expr, Expr)
  LetMut(Ident, TypeIdent, Expr, Expr)
  LetTuple(Array[Binding], TypeIdent?, Expr, Expr)
  LetFn(Ident, Func, Expr)
  // inst
  While(Expr, Expr, Expr)
  Assign(LExpr, Expr, Expr)
  Return(Expr)
  // branch
  If(Expr, Expr, Expr)
  Match(Expr, Array[(Pattern, Expr)])
  // apply
  Unary(Op1, Expr)
  Infix(Op2, Expr, Expr)
  Call(Expr, Array[Expr])
  Bucket(Expr, Expr)
  Dot(Expr, Ident)
  // construct
  Tuple(Array[Expr])
  Array(ConstrIdent, Array[Expr])
  Constr(Ident, Array[Expr])
  Struct(TypeIdent, Array[(Ident, Expr)])
} derive(ToJson(style="flat"))

///|
pub(all) enum LExpr {
  Ident(Ident)
  Dot(LExpr, Ident)
  Barket(LExpr, Expr)
} derive(ToJson(style="flat"))

///|
pub(all) enum Pattern {
  Any
  Lit(Lit)
  Var(Ident)
  Tuple(Array[Pattern])
  Constr(TypeIdent?, ConstrIdent, Array[Pattern])
} derive(ToJson(style="flat"))
