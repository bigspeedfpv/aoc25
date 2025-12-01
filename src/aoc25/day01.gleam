import aoc25/day99
import gleam/int
import gleam/io
import gleam/list
import gleam/string

import aoc25/common
import aoc25/input

const day = 1

pub fn part1(input: String) -> Int {
  let lines = common.lines(input)
  list.fold(lines, #(50, 0), fn(acc, line) {
    let #(pos, count) = acc
    let is_to_right = string.starts_with(line, "R")
    let assert Ok(degrees) = int.parse(string.drop_start(line, 1))

    let pos =
      case is_to_right {
        True -> pos + degrees
        False -> pos + 100 - degrees
      }
      % 100

    let count = case pos {
      0 -> count + 1
      _ -> count
    }

    #(pos, count)
  }).1
}

pub fn part2(input: String) -> Int {
  let lines = common.lines(input)
  list.fold(lines, #(50, 0), fn(acc, line) {
    let #(pos, count) = acc
    let is_to_right = string.starts_with(line, "R")
    let assert Ok(degrees) = int.parse(string.drop_start(line, 1))

    let #(pos, new_count) = move_dial(pos, is_to_right, degrees, 0)
    #(pos, count + new_count)
  }).1
}

// brute force. im lazy.
/// returns #(new_pos, times_passed_zero)
fn move_dial(
  pos: Int,
  right: Bool,
  clicks: Int,
  passed_zero: Int,
) -> #(Int, Int) {
  case clicks {
    0 -> #(pos, passed_zero)
    _ -> {
      let pos =
        case right {
          True -> pos + 1
          False if pos == 0 -> 99
          False -> pos - 1
        }
        % 100
      let passed_zero = case pos {
        0 -> passed_zero + 1
        _ -> passed_zero
      }
      move_dial(pos, right, clicks - 1, passed_zero)
    }
  }
}

/// Run by calling `gleam run -m aoc25/day99`.
pub fn main() -> Nil {
  let input = input.read_input(for: day)

  io.println("Part 1: " <> int.to_string(part1(input)))
  io.println("Part 2: " <> int.to_string(part2(input)))
}
