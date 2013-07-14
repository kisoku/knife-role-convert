name 'simple_role'
description 'simple test role for knife-role-coonvert'

run_list(
  "recipe[foo]"
)

override_attributes(
  "foo" => {
    "unicorn" => {
      "collect_tears" => true
    }
  },
  "bar" => 1,
  "quux" => %w{unos dos tres}
)
