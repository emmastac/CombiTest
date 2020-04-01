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

    func combinations(with factory: CITestSet.Factory) -> CITestSet {
        // Start with a DD that maps each parameter to an empty set of values.
        let initialMapping = Dictionary<ParameterKey, ParameterValue>(
            uniqueKeysWithValues: (0 ..< parameters.count).map({ paramID in
            (key: .param(id: paramID), value: ParameterValue(parameterID: paramID))
          }))
        var dd = factory.encode(family: [initialMapping])

        var morphisms: [AnyMorphism<ScheduleSet>] = []
        for (paramID, parameter) in parameters {

    // Compute the space of all possible parameter value assignments.
    let identity = factory.morphisms.identity
    let generator = factory.morphisms
      .fixedPoint(of: factory.morphisms.union(of: morphisms + [AnyMorphism(identity)]))
    dd = generator.apply(on: dd)

    // Filter out solutions that do not satisfy dependencies.
    let locator = ConstraintLocator(model: self, factory: factory)
    dd = locator.apply(on: dd)

    return dd
  }

}
