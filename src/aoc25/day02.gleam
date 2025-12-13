import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

import aoc25/common
import aoc25/input

const day = 2

pub fn part1(input: String) -> Int {
  parse(input)
  |> list.flat_map(fn(pair) {
    let #(a, b) = pair
    list.range(from: a, to: b)
  })
  |> list.filter(is_invalid)
  |> list.fold(0, int.add)
}

fn is_invalid(id: Int) -> Bool {
  let assert Ok(digits) = digits(id, 10)
  use <- bool.guard(when: int.is_odd(list.length(digits)), return: False)
  let #(a, b) = list.split(digits, at: list.length(digits) / 2)
  a == b
}

fn digits(x: Int, base: Int) -> Result(List(Int), Nil) {
  case base < 2 {
    True -> Error(Nil)
    False -> Ok(digits_loop(x, base, []))
  }
}

fn digits_loop(x: Int, base: Int, acc: List(Int)) -> List(Int) {
  case int.absolute_value(x) < base {
    True -> [x, ..acc]
    False -> digits_loop(x / base, base, [x % base, ..acc])
  }
}

pub fn part2(input: String) -> Int {
  todo
}

fn parse(input: String) -> List(#(Int, Int)) {
  input
  |> string.split(",")
  |> list.map(fn(pair) {
    let assert Ok(#(a, b)) = pair |> string.trim |> string.split_once("-")
    let assert Ok(a) = int.parse(a)
    let assert Ok(b) = int.parse(b)
    #(a, b)
  })
}

/// Run by calling `gleam run -m aoc25/day02`.
pub fn main() -> Nil {
  let input = input.read_input(for: day)

  io.println("Part 1: " <> int.to_string(part1(input)))
  io.println("Part 2: " <> int.to_string(part2(input)))
}
