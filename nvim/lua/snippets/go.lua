local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("go", {

  -- Main function
  s("main", fmt([[
    package main

    import "fmt"

    func main() {{
      {}
    }}
  ]], { i(1, 'fmt.Println("Hello, world!")') })),

  -- Function template
  s("func", fmt([[
    func {}({}) {} {{
      {}
    }}
  ]], {
    i(1, "Name"),
    i(2, "args"),
    i(3, "returnType"),
    i(4, "// TODO: implement"),
  })),

  -- Error check
  s("ife", fmt([[
    if err != nil {{
      return {}
    }}
  ]], { i(1, "err") })),

  -- Struct definition
  s("struct", fmt([[
    type {} struct {{
      {}
    }}
  ]], {
    i(1, "MyStruct"),
    i(2, "Field1 string\n\tField2 int"),
  })),

  -- Unit test function
  s("test", fmt([[
    func Test{}(t *testing.T) {{
      {}
    }}
  ]], {
    i(1, "FunctionName"),
    i(2, "// TODO: write test logic"),
  })),

  -- Interface definition
  s("iface", fmt([[
    type {} interface {{
      {}
    }}
  ]], {
    i(1, "MyInterface"),
    i(2, "DoSomething() error"),
  })),

  -- Import block
  s("imp", fmt([[
    import (
      "{}"
    )
  ]], { i(1, "fmt") })),

})
