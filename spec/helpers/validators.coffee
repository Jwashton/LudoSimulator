unique_elements = (array) ->
  array.filter (element, index, array) ->
    index == array.indexOf element

# Takes an array of integers and an integer length
# Verifies that the points are equally spaced assuming they are points
#   on a cyclical structure with a given length.
validate_equidistant = (points, length) ->
  unique = unique_elements(points)
  
  distance = length - points[points.length - 1]
  equidistant = true
  points.reduce (left, right) ->
    equidistant = false unless (right - left) in [distance, distance + 1]
    right
  
  # If all values are unique and equidistant
  unique.length == points.length and equidistant

# Spec
describe "validate_equidistant", ->
  it "succeeds given an evenly equidistant array", ->
    expect(validate_equidistant [0, 13], 26 ).toBeTruthy()
  
  it "succeeds within an acceptable tolerance for an undivisible array", ->
    expect(validate_equidistant [0, 17, 35], 52 ).toBeTruthy()
  
  it "fails if the points are not unique", ->
    expect(validate_equidistant [0, 0], 1 ).toBeFalsy()
  
  it "fails if the distances are not equal to each other", ->
    expect(validate_equidistant [0, 5, 7, 15], 20 ).toBeFalsy()
