func gcd(_ a: Int, _ b: Int) -> Int {
  let r = a % b
  if r == 0 {
    return b
  }
  return gcd(b, r)
}

func lcm(_ a: Int, _ b: Int) -> Int {
  return a * b / gcd(a, b)
}

func areaShoeLace(vertices: [Point]) -> Int {
  abs(
    vertices.adjacentPairs().reduce(
      0,
      { result, pair in
        let (p1, p2) = pair
        return result + p1.x * p2.y - (p1.y * p2.x)
      }
    ) / 2
  )
}

/// Interior Points using Pick's Theorem
func interiorPoints(area: Int, boundaryCount: Int) -> Int {
  return area - boundaryCount / 2 + 1
}
