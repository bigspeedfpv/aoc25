import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type TestCase {
  TestCase(part: Int, input: String, expected: Int)
}

fn read_inputs(for day: Int) -> Result(String, simplifile.FileError) {
  let filename =
    "./inputs/day"
    <> string.pad_start(int.to_string(day), to: 2, with: "0")
    <> ".txt"
  simplifile.read(from: filename)
}

type Section {
  Section(name: String, content: String)
}

/// Extracts a section's content, returning the rest of the file along with the section.
fn take_section(lines: List(String)) -> #(List(String), Section) {
  let assert [header, ..rest] = lines
  assert string.starts_with(header, "--")
  let name = string.drop_start(from: header, up_to: 2)
  let #(rest, content) = extract_until_next_mark(rest, "")
  #(rest, Section(name:, content:))
}

/// Takes lines until encountering the next mark, denoted by two hyphens.
fn extract_until_next_mark(
  lines: List(String),
  acc: String,
) -> #(List(String), String) {
  case lines {
    [] -> #(lines, acc)
    [line, ..rest] as lines ->
      case string.starts_with(line, "--") {
        True -> #(lines, acc)
        False -> extract_until_next_mark(rest, acc <> line <> "\n")
      }
  }
}

/// Reads sections until the end of the file.
fn read_sections(from contents: String) -> List(Section) {
  let lines = string.split(contents, on: "\n")
  let #(lines, _throwaway) = extract_until_next_mark(lines, "")
  read_sections_rec(lines, [])
}

fn read_sections_rec(lines: List(String), acc: List(Section)) -> List(Section) {
  case lines {
    [] -> list.reverse(acc)
    _ -> {
      let #(rest, section) = take_section(lines)
      read_sections_rec(rest, [section, ..acc])
    }
  }
}

pub fn read_test_cases(for day: Int) -> List(TestCase) {
  let assert Ok(contents) = read_inputs(for: day)
  read_sections(from: contents)
  |> list.filter(fn(section) {
    string.starts_with(section.name, "TESTCASE")
    || string.starts_with(section.name, "EXPECTED")
  })
  |> list.sized_chunk(into: 2)
  |> list.map(fn(p) {
    let assert [testcase, expected] = p
    assert string.starts_with(testcase.name, "TESTCASE")
    assert string.starts_with(expected.name, "EXPECTED")

    let assert Ok(part) =
      testcase.name
      |> string.split(" ")
      |> list.last
      |> result.map(int.parse)
      |> result.flatten

    let assert Ok(expected) = expected.content |> string.trim |> int.parse

    TestCase(part:, input: testcase.content, expected:)
  })
}

pub fn read_input(for day: Int) -> String {
  let assert Ok(contents) = read_inputs(for: day)
  let assert Ok(s) =
    read_sections(from: contents) |> list.find(fn(s) { s.name == "INPUT" })
  s.content
}
