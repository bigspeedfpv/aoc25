import aoc25/input
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string

const day = 99

pub fn part1(input: String) -> Int {
  let #(left, right) = parse_input(input)
  let left = list.sort(left, by: int.compare)
  let right = list.sort(right, by: int.compare)

  list.map2(left, right, fn(a, b) { int.absolute_value(int.subtract(a, b)) })
  |> list.fold(0, int.add)
}

pub fn part2(input: String) -> Int {
  let #(left, right) = parse_input(input)

  // generate the count of each number in advance
  let freqs =
    right
    |> list.fold(dict.new(), fn(acc, n) {
      dict.upsert(acc, n, fn(v) {
        case v {
          option.None -> 1
          option.Some(count) -> count + 1
        }
      })
    })

  left
  |> list.fold(0, fn(acc, n) {
    let freq = freqs |> dict.get(n) |> result.unwrap(0)
    acc + n * freq
  })
}

fn parse_input(input: String) -> #(List(Int), List(Int)) {
  input
  |> string.split("\n")
  |> list.filter(fn(l) { !string.is_empty(l) })
  |> list.map(fn(line) {
    let assert Ok(#(l, r)) = string.split_once(line, "   ")
    let assert Ok(l) = int.parse(l)
    let assert Ok(r) = int.parse(r)
    #(l, r)
  })
  |> list.unzip
}

/// Run by calling `gleam run -m aoc25/day99`.
pub fn main() -> Nil {
  let input = input.read_input(for: day)

  io.println("Part 1: " <> int.to_string(part1(input)))
  io.println("Part 2: " <> int.to_string(part2(input)))
}
