import DDKit

final class ConstraintLocator: Morphism {
  
  typealias DD = CITestSet
  
  /// The task model.
  public let model: ParameterModel
  
  /// The factory that creates the nodes handled by this morphism.
  public unowned let factory: CITestSet.Factory
  
  /// The morphism's cache.
  private var cache: [CITestSet.Pointer: CITestSet.Pointer] = [:]
  
  init(model: ParameterModel, factory: CITestSet.Factory) {
    self.model = model
    self.factory = factory
  }
  
  func apply(on pointer: CITestSet.Pointer) -> CITestSet.Pointer {
    // Check for trivial cases.
    guard !factory.isTerminal(pointer)
      else { return pointer }
    
    // Query the cache.
    if let result = cache[pointer] {
      return result
    }
    let result: CITestSet.Pointer
    
    if let parameter = model.parameters[pointer.pointee.key.paramID] {
      
      // The current parameter value has dependencies that should be checked. Therefore we need to compute
      // on each take branch the intersection of the DD returned by the recursive application of
      // this morphism (which will check dependencies for the remaining parameter values) with the DD
      // obtained after filtering out paths that do not satisfy this value's dependencies.
      var take = pointer.pointee.take.mapValues(apply(on:))
      for (arc, child) in take {
        let parameterValue = parameter.values[child]
        if parameterValue.excludedBy.isEmpty {
          // The current value has no dependencies, so we can just move on to the next.
          result = factory.node(
            key: pointer.pointee.key,
            take: pointer.pointee.take.mapValues(apply(on:)),
            skip: apply(on: pointer.pointee.skip))
        }
        
        let filter = factory.morphisms.saturate(
          factory.morphisms.uniquify(
            DependencyFilter(
              dependencies:  parameterValue.excludedBy,
//                .map({
//                model.parameters[$0.id], model.parameters[$0.id].values[$1.id]
//              }),
              model: model,
              factory: factory)))
        take[arc] = filter.apply(on: child)
      }
      
      result = factory.node(
        key: pointer.pointee.key,
        take: take,
        skip: apply(on: pointer.pointee.skip))
      
    } else {
      // This should be unreachable, as there can't be a task in the DD that wasn't in the model.
      fatalError("unreachable")
    }
    
    cache[pointer] = result
    return result
  }
  
  public func hash(into hasher: inout Hasher) {
  }
  
  static func == (
    lhs: ConstraintLocator,
    rhs: ConstraintLocator
  ) -> Bool {
    return lhs === rhs
  }
  
}
