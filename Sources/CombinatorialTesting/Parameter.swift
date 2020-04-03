
class Parameter {
    
    let id : Int
    
    let name : String
    
    let values : [ValueOption]
    
    init(id : Int, name: String, values: [ValueOption] = []) {
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
