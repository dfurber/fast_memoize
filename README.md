# FastMemoize
FastMemoize is a Ruby gem for memoization of method return values. The normal memoization in Ruby doesn't require any gems and looks like this:

```ruby
class Post
  def user
    @user ||= User.find(user_id)
  end
end
```
However, this approach doesn't work if calculated result can be nil or false or in case the method is using arguments. You will also require extra begin/end lines in case your method requires multiple lines:

```ruby
class Post
  def user
    @user ||= begin
                user_id = calculate_id
                klass = calculate_klass
                klass.find(user_id) 
              end
  end
end
```

But if `User.find` returns `nil` if the user can't be found, then repeated calls to the method will result in the `find` call being re-executed. The usual way around this is to add a `defined?` check at the top of the method:
```ruby
class Post
  def user
    return @user if defined?(@user)

    @user = begin
              user_id = calculate_id
              klass = calculate_klass
              klass.find(user_id) 
            end
  end
end
```
By this time, your code has gotten pretty ugly just to make use of memoization. Not to mention the tedious typing out of all that extra code.

So you'll find yourself skipping the memoization, or inlining code you would otherwise extract to a method because then it would be "memoized" in the variable. But then you end up with long methods and high complexity.

For all these situations memoization gems (like this one) exist. The last example can be rewritten using fast_memoize like this:
```ruby
class Post
  include FastMemoize
  def user
    some_id = calculate_id
    klass = calculate_klass
    klass.find(some_id)
  end
  memoize :user
end
```

All of the memoization gems do something like this. But they also do a lot more. If you know what those things are, and you need them, then please use them. But if all you're looking for in a memoization gem is a shorthand for the `return @my_method if defined?(@my_method); @my_method = yada_yada` then this gem is for you. The performance improvement over the other memoization gems is noticeable (performing a trivival memoized operation 10,000 times with each gem):
```
       user     system      total        real
Memery
0.024411   0.002062   0.026473 (  0.026478)
Memoist
0.013781   0.000000   0.013781 (  0.013796)
Memoizable
0.041890   0.000000   0.041890 (  0.041913)
FastMemoize
0.004280   0.000000   0.004280 (  0.004285)
Standard Method
0.003760   0.000000   0.003760 (  0.003761)
```
FastMemoize takes slightly longer than the standard inline method because it must call the original method, which has been aliased as `memoized_method_name`. It is still an order of magnitude faster than the alternatives.

## Caveats
The `memoize` call only accepts one method name. You must place it after the method is defined. The best place is the line after you define the method.

If the method hasn't been defined yet, it will blow up.

Also, the memoized method can't take arguments. That calls for a different approach to memoization. You should still handle that yourself. This gem is just for the simple cases that you typically meet with `@method_name ||=`. FastMemoize will throw an error if you attempt to memoize a method that takes parameters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast_memoize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fast_memoize

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fast_memoize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FastMemoize project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fast_memoize/blob/master/CODE_OF_CONDUCT.md).
