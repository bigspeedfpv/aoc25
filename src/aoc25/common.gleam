import gleam/list
import gleam/string

pub fn lines(s: String) -> List(String) {
  s |> string.split("\n") |> list.filter(fn(l) { !string.is_empty(l) })
}
