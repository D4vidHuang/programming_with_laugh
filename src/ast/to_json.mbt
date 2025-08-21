///|
pub impl ToJson for Lit with to_json(self) {
  match self {
    Unit => "()"
    Bool(b) => Json::boolean(b)
    Int(i) => Json::number(i.to_double())
    Float(d) => Json::number(d)
  }
}

///|
pub impl ToJson for Binding with to_json(self) {
  match self {
    Ident(id) => Json::string(id)
    Wildcard => "_"
  }
}

///|
pub impl ToJson for TypeIdent with to_json(self) {
  Json::string(self.0)
}

///|
pub impl ToJson for ConstrIdent with to_json(self) {
  Json::string(self.0)
}
