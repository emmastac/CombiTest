import DDKit

func print(test: [ParameterKey : ParameterValue]) {
  let parameters = test.keys

//    print(parameters.map({ String(describing: id) }).joined(separator: ", "))
  
}

let factory = CITestSet.Factory()



let paramModel = ParameterModel {
 
    let values0 = [
        ParameterValue(id: 0, name : "B4" ),
        ParameterValue(id: 1, name : "A4" ),
        ParameterValue(id: 2, name : "B5" )]
  
/// excludedBy dependencies, for now, are only tuples of ids (parameterVariable, parameterValue )
/// e.g. B4 => Bypass, means that Tray1 and Tray2 values are excluded by the existence of PaperTray=B4.
/// We assume also that PaperTray precedes FeedTray in the order of nodes.
    let values1 = [
        ParameterValue(id: 0, name : "Bypass" ),
        ParameterValue(id: 1, name : "Tray1", excludedBy: [(0, 0)] ), // B4 excludes
        ParameterValue(id: 2, name : "Tray2", excludedBy: [(0, 0)] )]
    
    let values2 = [
        ParameterValue(id: 0, name : "Thick" , excludedBy: [(1, 0)]),
        ParameterValue(id: 1, name : "Normal" ),
        ParameterValue(id: 2, name : "Thin" )]
    
  let p2 = Parameter(id: 2, name: "Paper type", values: values2 )
  let p1 = Parameter(id: 1, name: "Feed tray", values: values1 )
  let p0 = Parameter(id: 0, name: "Paper size", values: values0 )
    
    
/// B4 => Bypass
/// Bypass => ! Thick
    
  return [p0, p1, p2]
}

let tests = paramModel.combinations(with: factory)
print("Number of possible testCombinations: \(tests.count)")
print("Number of nodes created: \(factory.createdCount)\n")

//print(schedulings.randomElement() as Any)
//if let scheduling = schedulings.randomElement() {
//  print(scheduling: scheduling)
//}
for test in tests {
  print(test: test)
  print()
}
