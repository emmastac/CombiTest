class ValueOption {
    
    let id : Int
    
    let name : String
    
    let excludedBy : [(Int, Int)]
    
    init(id : Int, name: String, excludedBy : [(Int, Int)] = [] ) {
      self.id = id
      self.name = name
      self.excludedBy = excludedBy
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
