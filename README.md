# Redikey

Redikey encapsulates the Redis hash key pattern [defined here](http://instagram-engineering.tumblr.com/post/12202313862/storing-hundreds-of-millions-of-simple-key-value).

The most common usage was to group values into common key prefixes ('milestones' or 'str_report', etc) and then taking the user_id of the user we want to store or retrieve data in redis for (e.g. 5000000) and then making the hash key by taking the user_id and dividing by 512, which would become: `milestones:9765`.

Inside that hash key, we'd create a field based again on the user's user_id, but this time, instead of dividing, we mod: `320`

So the redis operation to set a value for user 5000000 would be:

```
redis.hset('milestones:9765', '320', some_value)
```

If the user's user_id was 5000001, the redis operation would look like this:

```
redis.hset('milestones:9765', '321', some_other_value)
```

Redikey simplifies this math, and creates a simple api to retrieve those keys for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redikey'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redikey

## Usage

To initialize the Redikey KeyHelper:

`Redikey::KeyHelper.new(resource_id, separator: ':', prefixes: [])`

- **Required** The resource_id (e.g. a user_id)
- *Optional* separator: A separator to use between prefixes or parts of the key (defaults to ':')
- *Optional* prefixes: An array of strings that will become prefixes for your key. (defaults to [])


```
redikey = Redikey::KeyHelper.new(1, separator: '/', prefixes: [:prefix1, :prefix2, :prefixn])

redikey.key #=> 'prefix1/prefix2/prefixn/0'
redikey.field_key => '1'
```

Without any prefixes
```
redikey = Redikey::KeyHelper.new(1)
redikey.key #=> '0'
redikey.field_key #=> '1'
```

You can also add an additional prefix that will be added to the end of any existing prefixes:
```
redikey.key(:foo) #=> 'foo:0'

redikey = Redikey::KeyHelper.new(1, prefixes: [:prefix1, :prefix2, :prefixn])
redikey.key(:foo) #=> 'prefix1:prefix2:prefixn:foo:0'
```

Now that you have the keys you need for the hash, and the field, you can use Redis' `hset` command:

```
redis.hset(redikey.key, redikey.field_key, some_value)
```

And to read from the hash:

```
redis.hget(redikey.key, redikey.field_key)
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/redikey/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
