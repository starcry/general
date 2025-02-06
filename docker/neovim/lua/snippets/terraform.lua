local luasnip = require("luasnip")

luasnip.add_snippets("terraform", {

  -- Terraform Resource
  luasnip.snippet("resource", {
    luasnip.text_node("resource \""), luasnip.insert_node(1, "aws_instance"), luasnip.text_node("\" \""),
    luasnip.insert_node(2, "example"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  "}), luasnip.insert_node(3, "# config goes here"),
    luasnip.text_node({"", "}"}),
  }),

  -- Terraform Module
  luasnip.snippet("module", {
    luasnip.text_node("module \""), luasnip.insert_node(1, "module_name"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  source = \""}), luasnip.insert_node(2, "./modules/example"), luasnip.text_node("\""),
    luasnip.text_node({"", "  "}), luasnip.insert_node(3, "# additional config"),
    luasnip.text_node({"", "}"}),
  }),

  -- Terraform Variable
  luasnip.snippet("variable", {
    luasnip.text_node("variable \""), luasnip.insert_node(1, "var_name"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  type = "}), luasnip.insert_node(2, "\"string\""),
    luasnip.text_node({"", "  default = "}), luasnip.insert_node(3, "\"value\""),
    luasnip.text_node({"", "}"}),
  }),

  -- Terraform Output
  luasnip.snippet("output", {
    luasnip.text_node("output \""), luasnip.insert_node(1, "output_name"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  value = "}), luasnip.insert_node(2, "resource.example.id"),
    luasnip.text_node({"", "}"}),
  }),

  -- Terraform Provider
  luasnip.snippet("provider", {
    luasnip.text_node("provider \""), luasnip.insert_node(1, "aws"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  region = \""}), luasnip.insert_node(2, "us-east-1"), luasnip.text_node("\""),
    luasnip.text_node({"", "}"}),
  }),

  -- Terraform Data Source
  luasnip.snippet("data", {
    luasnip.text_node("data \""), luasnip.insert_node(1, "aws_ami"), luasnip.text_node("\" \""),
    luasnip.insert_node(2, "example"), luasnip.text_node("\" {"),
    luasnip.text_node({"", "  "}), luasnip.insert_node(3, "# config"),
    luasnip.text_node({"", "}"}),
  }),

  -- Terraform Locals
  luasnip.snippet("locals", {
    luasnip.text_node("locals {"),
    luasnip.text_node({"", "  "}), luasnip.insert_node(1, "computed_value = \"value\""),
    luasnip.text_node({"", "}"}),
  }),

})
