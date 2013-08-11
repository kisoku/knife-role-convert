name 'simple_role'
description 'simple test role for knife-role-convert'

run_list(
  "recipe[foo]"
)

override_attributes(
  "foo" => {
    "unicorn" => {
      "collect_tears" => true,
      "nested" => {
        "should_not_inspect_the_contents" => [
          { :lambda => 'lambda' },
          { :lambda => 'mu' }
        ]
      }
    }
  },
  "bar" => 1,
  "baz" => 2.2,
  "quux" => %w{unos dos tres}
)
