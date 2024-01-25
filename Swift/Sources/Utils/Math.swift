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
