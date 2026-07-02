# frozen_string_literal: true

name 'memcached'

run_list 'test::default'

cookbook 'memcached', path: '.'
cookbook 'test', path: './test/cookbooks/test'

%w(default instance).each do |recipe_name|
  named_run_list recipe_name.to_sym, "test::#{recipe_name}"
end
