import DDKit


typealias CITestSet = MFDD<ParameterKey, ParameterValue>

func print(dd : CITestSet) {
  let node : MFDD<ParameterKey,ParameterValue>.Node = dd.pointer.pointee
  for next in node.take{
    print("( \(node.key.paramID), \(next.key.valueID)) , \(next.value.pointee.key.paramID))")
  }
  let skip = node.skip.pointee
  print("( \(node.key.paramID), empty , \(skip.key.paramID))")
  
  
}

let factory = CITestSet.Factory()



let paramModel = ParameterModel {
 
    let values0 = [
        ValueOption(id: 0, name : "B4" ),
        ValueOption(id: 1, name : "A4" ),
        ValueOption(id: 2, name : "B5" )]
  
/// excludedBy dependencies, for now, are only tuples of ids (parameterVariable, parameterValue )
/// e.g. B4 => Bypass, means that Tray1 and Tray2 values are excluded by the existence of PaperTray=B4.
/// We assume also that PaperTray precedes FeedTray in the order of nodes.
    let values1 = [
        ValueOption(id: 0, name : "Bypass" ),
        ValueOption(id: 1, name : "Tray1", excludedBy: [(0, 0)] ), // B4 excludes
        ValueOption(id: 2, name : "Tray2", excludedBy: [(0, 0)] )]
    
    let values2 = [
        ValueOption(id: 0, name : "Thick" , excludedBy: [(1, 0)]),
        ValueOption(id: 1, name : "Normal" ),
        ValueOption(id: 2, name : "Thin" )]
    
  let p2 = Parameter(id: 2, name: "Paper type", values: values2 )
  let p1 = Parameter(id: 1, name: "Feed tray", values: values1 )
  let p0 = Parameter(id: 0, name: "Paper size", values: values0 )
  
/// Create all possible combinations
  
  /// Constraints
  /// B4 => Bypass  which is expressed as  ! B4 or Bypass
//  let c1 = Expression( part1: Expression (part1: Equality( p0, values0[0]), op: Operator.negation),
//                       part2: Equality( p1, values1[0]),
//                       op : Operator.union)
//
//  /// Bypass => ! Thick which is expressed as  ! Bypass or !Thick
//  let c1 = Expression( part1: Expression (part1: Equality( p1, values1[0]), op: Operator.negation),
//                       part2: Expression (part1: Equality( p2, values2[0]), op: Operator.negation),
//                       op : Operator.union)
//
return [p0, p1, p2]
  
  
}



let tests = paramModel.combinations(with: factory)
print("Number of possible testCombinations: \(tests.count)")
print("Number of nodes created: \(factory.createdCount)\n")
print(tests)

//print(schedulings.randomElement() as Any)
//if let scheduling = schedulings.randomElement() {
//  print(scheduling: scheduling)
//}
