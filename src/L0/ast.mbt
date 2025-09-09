///|
pub(all) struct Program {
  type_decls : Array[(TypeIdent, TypeDecl)]
  top_lets : Array[(Ident, TypeExpr, Expr)]
  top_funcs : Array[TopFunc]
  main_func : Expr
} derive(ToJson)

///|
pub(all) enum TypeDecl {
  Struct(Array[(Ident, TypeExpr)])
  Enum(Array[(ConstrIdent, Array[TypeExpr])])
} derive(ToJson(style="flat"))

///|
pub(all) struct TopFunc {
  name : Ident
  params : Array[(Ident, TypeExpr)]
  return_type : TypeExpr
  body : Expr
} derive(ToJson)

///|
pub(all) struct Func {
  params : Array[(Ident, TypeExpr?)]
  return_type : TypeExpr?
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
  /// 字面量
  Lit(Lit)
  /// 变量
  Var(Ident)

  // let
  /// let binding : T1 = e1 ; e2
  Let(Binding, TypeExpr?, Expr, Expr)
  /// let mut x1 : T1 = e1 ; e2
  LetMut(Ident, TypeExpr, Expr, Expr)
  /// let (x1, x2, ...) : T1 = e1 ; e2
  LetTuple(Array[Binding], TypeExpr?, Expr, Expr)
  /// fn x1(..) { .. } ; e
  LetFn(Ident, Func, Expr)

  // inst
  /// while e1 { e2 } ; e3
  While(Expr, Expr, Expr)
  /// lexp = e1 ; e2
  Assign(LExpr, Expr, Expr)
  /// return e
  Return(Expr)

  // branch
  /// if e1 { e2 } else { e3 }
  If(Expr, Expr, Expr)
  /// match e0 { p1 => e1 ; p2 => e2 ; ... }
  Match(Expr, Array[(Pattern, Expr)])

  // apply
  /// 一元运算
  Unary(Op1, Expr)
  /// 二元运算
  Infix(Op2, Expr, Expr)
  /// e0(e1, e2, ...)
  Call(Expr, Array[Expr])
  /// e0[e1]
  Bucket(Expr, Expr)
  /// e.field
  Dot(Expr, Ident)

  // construct
  /// (e1, e2, ...)
  Tuple(Array[Expr])
  /// [e1, e2, ...]
  Array(Array[Expr])
  /// Ty::Cons(e1, e2, ...)
  Constr(TypeIdent?, ConstrIdent, Array[Expr])
  /// Ty::{ i1: e2, i2: e2, ... }
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
pub(all) enum TypeExpr {
  Ident(TypeIdent)
  Generic(TypeIdent, Array[TypeExpr])
  Tuple(Array[TypeExpr])
  Func(Array[TypeExpr], TypeExpr)
} derive(ToJson(style="flat"))
