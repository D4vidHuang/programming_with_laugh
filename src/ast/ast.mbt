///|
pub(all) struct Program {
  type_decls : Array[(TypeIdent, TypeDecl)]
  top_let : Array[(Ident, Type, Expr)]
  top_fns : Array[(Ident, Func)]
  main_fn : Func
} derive(ToJson)

///|
pub(all) enum TypeDecl {
  Struct(Array[(Ident, Type)])
  Enum(Array[(ConstrIdent, Array[Type])])
} derive(ToJson(style="flat"))

///|
pub(all) struct Func {
  params : Array[(Ident, Type?)]
  return_type : Type?
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
  Let(Binding, Type?, Expr, Expr)
  LetMut(Ident, Type, Expr, Expr)
  LetTuple(Array[Binding], Type?, Expr, Expr)
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
  Array(Array[Expr])
  Constr(TypeIdent?, ConstrIdent, Array[Expr])
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

///|
pub(all) enum Type {
  Ident(TypeIdent)
  Generic(TypeIdent, Array[Type])
  Tuple(Array[Type])
  Func(Array[Type], Type)
} derive(ToJson(style="flat"))
