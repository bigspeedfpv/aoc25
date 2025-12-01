import aoc25/day01
import gleam/int
import gleam/io
import gleam/list

import gleeunit

import aoc25/day99
import aoc25/input

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn yr24_day01_test() {
  input.read_test_cases(for: 99)
  |> list.each(fn(spec) {
    io.println("Running test case for part " <> int.to_string(spec.part))
    let cb = case spec.part {
      1 -> day99.part1
      2 -> day99.part2
      part -> panic as { "invalid part number " <> int.to_string(part) }
    }
    assert spec.expected == cb(spec.input)
  })
}

pub fn day01_test() {
  input.read_test_cases(for: 1)
  |> list.each(fn(spec) {
    io.println("Running test case for part " <> int.to_string(spec.part))
    let cb = case spec.part {
      1 -> day01.part1
      2 -> day01.part2
      part -> panic as { "invalid part number " <> int.to_string(part) }
    }
    assert spec.expected == cb(spec.input)
  })
}
