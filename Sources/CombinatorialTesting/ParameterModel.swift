import DDKit

/// A task model.
struct ParameterModel {
  
  /// The params contained in this model.
  let parameters: [Int: Parameter]
  
  init(parameters: Set<Parameter>) {
    /// create a map from IDs to param objects
    self.parameters = Dictionary(uniqueKeysWithValues: parameters.map({ param in
      (key: param.id, value: param)
    }))
  }
  
  init(parameters: () throws -> Set<Parameter>) rethrows {
    self.init(parameters: try parameters())
  }
  
  func computeCartesian( parameters : [Int: Parameter], index : Int ) -> [Dictionary<ParameterKey, ParameterValue>]{
    var result : [Dictionary<ParameterKey, ParameterValue>] = []
    if let param = parameters[index] {
      let key : ParameterKey = .param(id: param.id)
      
      
      if(index == parameters.count-1){
        /// Create a dictionary for each value
        let dictionaries : [Dictionary<ParameterKey, ParameterValue>] = (param.values).map( {
          (v : ValueOption ) -> Dictionary<ParameterKey, ParameterValue> in
          let val = ParameterValue( valueID: v.id )
          var dict = Dictionary<ParameterKey, ParameterValue> ()
          dict[key] = val
          return dict
        })
        /// add all dictionaries to the result
        result.append( contentsOf: dictionaries )
        
      }else{
        /// create dictionaries' list for next parameter
        let dictionaries = computeCartesian( parameters : parameters, index : index+1 )
        /// repeat all lists for each value
        for v in param.values{
          let val = ParameterValue( valueID: v.id )
          let newDictionaries = dictionaries.map({
            (d : Dictionary<ParameterKey, ParameterValue>) -> Dictionary<ParameterKey, ParameterValue> in
            var copyOfd = d
            copyOfd[key] = val
            return copyOfd
          })
          
          /// add all dictionaries to the result
          result.append( contentsOf: newDictionaries )
        }
        
      }
      
    }else {
      // This should be unreachable, as there can't be an index that is not mapped to a parameter.
      fatalError("unreachable")
    }
    return result
  }
  
  func combinations(with factory: CITestSet.Factory) -> CITestSet {
    // Start with a DD that has all possible parameter to value mappings.
    let initialMapping: [ Dictionary<ParameterKey, ParameterValue> ] =
      computeCartesian(parameters: parameters, index: 0)
    
    var dd = factory.encode(family: initialMapping)
    
//    var morphisms: [AnyMorphism<CITestSet>] = []
//    for (paramID, parameter) in parameters {
//
//      // Compute the space of all possible parameter value assignments.
//      let identity = factory.morphisms.identity
//      let generator = factory.morphisms
//        .fixedPoint(of: factory.morphisms.union(of: morphisms + [AnyMorphism(identity)]))
//      dd = generator.apply(on: dd)
//
//      // Filter out solutions that do not satisfy dependencies.
//      let locator = ConstraintLocator(model: self, factory: factory)
//      dd = locator.apply(on: dd)
//      
//    }

    return dd
  }
}
