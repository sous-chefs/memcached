if defined?(ChefSpec)
  %i(create delete enable disable start stop restart).each do |action|
    define_method(:"#{action}_memcached_instance") do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(:memcached_instance, action, resource_name)
    end
  end
end
