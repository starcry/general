local luasnip = require("luasnip")

luasnip.add_snippets("terraform", {
  -- Terraform Resource
  luasnip.snippet("resource", {
    luasnip.text_node("resource \""), luasnip.insert_node(1, "aws_instance"), luasnip.text_node("\" \""),
    luasnip.insert_node(2, "example"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  "}), luasnip.insert_node(3, "config"),
    luasnip.text_node({"", "}"}),
  }),

  -- Terraform Module
  luasnip.snippet("module", {
    luasnip.text_node("module \""), luasnip.insert_node(1, "module_name"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  source = \""}), luasnip.insert_node(2, "./path/to/module"), luasnip.text_node("\""),
    luasnip.text_node({"", "}"}),
  }),

  -- Terraform Variable
  luasnip.snippet("variable", {
    luasnip.text_node("variable \""), luasnip.insert_node(1, "var_name"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  type = "}), luasnip.insert_node(2, "\"string\""),
    luasnip.text_node({"", "}"}),
  }),
})
