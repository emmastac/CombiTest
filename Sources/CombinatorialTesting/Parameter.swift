
class Parameter {
    
    let id : Int
    
    let name : String
    
    let values : Set<String>
    
    init(id : Int, name: String, values: Set<String> = []) {
      self.id = id
      self.name = name
      self.values = values
    }
}

extension Parameter: Hashable {

  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }

  static func == (lhs: Parameter, rhs: Parameter) -> Bool {
    return lhs === rhs
  }

}
