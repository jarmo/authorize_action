# AuthorizeAction

Really **secure** and **simple** authorization library for your [Rails](http://rubyonrails.org/), [Sinatra](http://www.sinatrarb.com/) or whatever web framework which doesn't suck.

According to [Ruby Toolbox](https://www.ruby-toolbox.com/categories/rails_authorization) there are at least 28 libraries/frameworks available just for Rails. And yet, they all suck. At least that's why i've never used any of them in my projects. All of this is the reason i've finally decided to create my own library to solve the problem of authorization once and for all for all Ruby (web) frameworks.

Here are few reasons, why [authorize_action](https://github.com/jarmo/authorize_action) library is better compared to all the rest:
* Is **secure** by default
  * _authorize_action_ uses **white-list** approach, which means that all controller actions are forbidden by default.
  
* Does only **one** thing and does it well
  * _authorize_action_ doesn't deal with any other thing except **authorization**. It does not provide you any authentication (see [Devise](https://github.com/plataformatec/devise) for that), roles or permissions functionality. It just checks if user has access to controller action or not. That's it.

* Has a really **simple** API
  * _authorize_action_ doesn't have _gazillion_ different API methods, separate DSL language or _"Getting Started"_ wiki pages. It just has a **few methods** to do all the heavylifting. And it's really easy to understand by looking at the code in your project, who has access to which controller action.

* Is **framework-agnostic**
  * Although _authorize_action_ is made to work with _Rails_ and _Sinatra_ by default, it has an **easy** way to add support for whatever framework.

* No **database/ORM** dependencies
  * _authorize_action_ **doesn't force** you to use any database/ORM - handle your roles/permissions however you need.

* No **external** dependencies
  * _authorize_action_ doesn't have any direct external dependencies, which makes auditing it's code and upgrading it really **painless**.

* Has a **lightweight** codebase
  * Due to simplicity of _authorize_action_ it's codebase is really simple, clean and foolproof. Entire codebase used in _production_ is just about **~60 lines**. If you're not sure what exactly happens when you use _authorize_action_ in your project then you can understand it quickly by looking at [the code](https://github.com/jarmo/authorize_action/tree/master/lib).

* Is thoroughly **tested**
  * _authorize_action_ has **100% code-coverage** and all tests are ran automatically prior to each release making it impossible to release a faulty version.

* Follows **Semantic Versioning**
  * Although _authorize_action_ is a relatively new library for now, it's going to follow [Semantic Versioning](http://semver.org/), which adds some additional guarantees to developers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'authorize_action'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install authorize_action

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/authorize_action/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
