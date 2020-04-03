import DDKit

/// typealias ScheduleSet = MFDD<ScheduleKey, ScheduleValue>

/// A MFDD key representing a parameter variable
///
/// This struct acts as a convenience wrapper around a simple integer value. It uses  64  bits to store an ID.
/// As a result, the raw value of a core ID is always negative.
struct ParameterKey: Hashable {

  fileprivate let value: Int64
    
  var paramID : Int { Int(value) }

  static func param(id: Int) -> ParameterKey {
    return ParameterKey(value: Int64(id))
  }

}

extension ParameterKey: Comparable {

  static func < (lhs: ParameterKey, rhs: ParameterKey) -> Bool {
    lhs.value < rhs.value
  }

}

extension ParameterKey: CustomStringConvertible {

  var description: String {
    return "parameter(\(value))"
  }

}

/// A MFDD arc value representing a value if a parameter variable.
struct ParameterValue: Hashable {

  private let value: Int64

  var valueID: Int { Int(value) }

  init(valueID: Int) {
    value = Int64(valueID)
  }

}

extension ParameterValue: CustomStringConvertible {

  var description: String {
    return "(parID: \(valueID)"
  }

}
