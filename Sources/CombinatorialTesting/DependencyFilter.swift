import DDKit

final class DependencyFilter: Morphism, MFDDSaturable {

  typealias DD = CITestSet

  /// The IDs of each dependency that has to be checked.
  public let dependencies: [(Int, Int)]

  /// The task model.
  public let model: ParameterModel

  /// The next morphism to apply once the first assignment has been processed.
  private var next: CITestSet.SaturatedMorphism<TaskDependencyFilter>?

  /// The factory that creates the nodes handled by this morphism.
  public unowned let factory: CITestSet.Factory

  /// The morphism's cache.
  private var cache: [CITestSet.Pointer: CITestSet.Pointer] = [:]

//  public var lowestRelevantKey: ParameterKey { .task(id: dependencies.min()!) }

  init(dependencies: [(Int, Int)], model: PropertyModel, factory: CITestSet.Factory) {
    assert(dependencies.count > 0)
//    Assume dependencies are already sorted
//    self.dependencies = dependencies.sorted()
    self.next = dependencies.count > 1
      ? factory.morphisms.saturate(
        factory.morphisms.uniquify(DependencyFilter(
          dependencies: Array(self.dependencies.dropFirst()),
          model: model,
          factory: factory)))
      : nil

    self.model = model
    self.factory = factory
  }

  func apply(on pointer: CITestSet.Pointer) -> CITestSet.Pointer {
    // Check for trivial cases.
    guard !factory.isTerminal(pointer)
      else { return factory.zero.pointer }

    // Query the cache.
    if let result = cache[pointer] {
      return result
    }
    let result: CITestSet.Pointer

    // Check if this is a node to which there is a dependency
    if pointer.pointee.key < .param(id: dependencies[0][0]) {
      // Just move down to the next node.
      result = factory.node(
        key: pointer.pointee.key,
        take: pointer.pointee.take.mapValues(apply(on:)),
        skip: apply(on: pointer.pointee.skip))
    } else if pointer.pointee.key == .param(id: dependencies[0][0]) {
      // check all arcs
      // Retrieve the node's description from the model.
      let task = model.tasks[pointer.pointee.key.taskID]!

      // Only keep take branches for which the time at which the task will be completed is lower or
      // equal to this morphism's deadline.
      var take: [ScheduleValue: ScheduleSet.Pointer] = [:]
      for (arc, child) in pointer.pointee.take where arc.clock + task.wcet <= deadline {
        take[arc] = next?.apply(on: child) ?? child
      }

      result = factory.node(
        key: pointer.pointee.key,
        take: take,
        skip: factory.zero.pointer)
    } else {
      result = factory.zero.pointer
    }

    cache[pointer] = result
    return result
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(dependencies)
    hasher.combine(deadline)
  }

  static func == (lhs: DependencyFilter, rhs: DependencyFilter) -> Bool {
    return (lhs.dependencies == rhs.dependencies)
        && (lhs.deadline == rhs.deadline)
  }

}
