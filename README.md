# AuthorizeAction

[![Gem Version](https://badge.fury.io/rb/authorize_action.svg)](http://badge.fury.io/rb/authorize_action)
[![Build Status](https://api.travis-ci.org/jarmo/authorize_action.png)](http://travis-ci.org/jarmo/authorize_action)
[![Coverage Status](https://coveralls.io/repos/jarmo/authorize_action/badge.svg?branch=master)](https://coveralls.io/r/jarmo/authorize_action?branch=master)
[![Dependency Status](https://gemnasium.com/jarmo/authorize_action.png)](https://gemnasium.com/jarmo/authorize_action)
[![Code Climate](https://codeclimate.com/github/jarmo/authorize_action/badges/gpa.svg)](https://codeclimate.com/github/jarmo/authorize_action)

Really **secure** and **simple** authorization library for your [Rails](http://rubyonrails.org/), [Sinatra](http://www.sinatrarb.com/) or whatever web framework, which just works.

According to [Ruby Toolbox](https://www.ruby-toolbox.com/categories/rails_authorization) there are
at least 28 authorization libraries/frameworks available just for Rails. And yet, they all seem to be overly complex or insecure by default.
At least that's why I've never used any of them in my projects.
All of this is the reason I've finally decided to create my own library to solve
the problem of authorization once and for all for all Ruby (web) frameworks.

Here are a few reasons, why [authorize_action](https://github.com/jarmo/authorize_action) is better
compared to all the rest:

* Is **secure** by default
  * _authorize_action_ uses a **white-list** approach, which means that all controller actions 
    are forbidden by default. No more security breaches when you forget to write an authorization rule.
  
* Does only **one** thing and does it well
  * _authorize_action_ doesn't deal with any other thing except **authorization**.
    It does not provide any authentication (see [Devise](https://github.com/plataformatec/devise) for that),
    roles or permissions functionality. It just checks if a user has access to a controller action or not. That's it.

* Has a really **simple** API
  * _authorize_action_ doesn't have _gazillion_ different API methods, separate DSL
    or _"Getting Started"_ wiki pages. It just has a **few methods** to do all the heavy lifting.
    And it's really easy to understand by looking at the code in your project,
    who has access to which controller action.

* Is **framework-agnostic**
  * Although _authorize_action_ is made to work with _Rails_ and _Sinatra_ by default,
    it has an **easy** way to add support for whatever framework.

* No **database/ORM** dependencies
  * _authorize_action_ **doesn't force** you to use any database/ORM - handle
     your roles/permissions however you like.

* No **external** dependencies
  * _authorize_action_ doesn't have any direct external dependencies, which
    makes auditing its code and upgrading it really **painless**.

* Has a **lightweight** codebase
  * Due to the simplicity of _authorize_action_ its codebase is really simple, clean and foolproof.
    Entire codebase used in _production_ is under **100 lines**.
    If you're not sure what exactly happens when you use _authorize_action_ in your project
    then you can understand it all quickly by looking at [the code](https://github.com/jarmo/authorize_action/tree/master/lib).

* Is thoroughly **tested**
  * _authorize_action_ has **100% code-coverage** and all tests are ran automatically
    prior to each release making it impossible to ship a faulty version accidentally.

* Follows **Semantic Versioning**
  * Although _authorize_action_ is a relatively new library for now,
    it's going to follow [Semantic Versioning](http://semver.org/),
    which adds some additional guarantees to developers.

* Is cryptographically **signed**
  * _authorize_action_ is one of these few gems which are cryptographically signed so you can be sure
    that the code you're running is signed by me. In addition, I have a [calculated checksum](https://github.com/jarmo/authorize_action/tree/master/checksum) for each gem
    version to be extra sure.

## Installation

_authorize_action_ is cryptographically signed. To be sure the gem you install hasn’t been tampered with:

* Verify gem checksum:

        $ gem fetch authorize_action && \
            ruby -rdigest/sha2 -e "puts Digest::SHA512.new.hexdigest(File.read(Dir.glob('authorize_action-*.gem')[0]))" && \
            curl -Ls https://raw.githubusercontent.com/jarmo/authorize_action/master/checksum/`ls authorize_action-*.gem`.sha512

* Add my public key (if you haven’t already) as a trusted certificate:

`$ gem cert --add <(curl -Ls https://raw.github.com/jarmo/authorize_action/master/certs/jarmo.pem)`

* Add this line to your application's Gemfile:

```ruby
gem 'authorize_action'
```

* And then execute:
 
`$ bundle install --trust-policy HighSecurity`

* Or install it yourself as:

`$ gem install authorize_action --trust-policy HighSecurity`

## Usage

* Load _authorize_action_ gem
* Include framework specific module into base controller
* Define authorization rules for each controller/class
* Call `#authorize_action!` method before executing action

### Rails

```ruby
class ApplicationController < ActionController::Base
  # Include authorize_action methods
  include AuthorizeAction::Rails
  
  # Check action authorization before action.
  # By default all actions are forbidden!
  before_action :authorize_action!
  
  protected
  
  # Helper method for administrator role
  def admin?
    # ...
  end
end

class PostsController < ApplicationController
  # Everyone has access to :index
  def index
    # ...
  end
  
  # Only post owner has access to :edit 
  def edit
    # ...
  end
  
  # Authorization rules have to be defined for each controller
  # action to specify the actual access rules.
  self.authorization_rules = {
    # Calling Proc object for :index action returns true
    # thus everyone will have access to that action
    index: -> { true },
   
    # Calling Proc object for :edit action returns true only
    # when Post owner matches current_user
    edit: -> { Post.find(params[:id]).owner == current_user },
    
    # Calling referenced #admin? method for :destroy action
    # returns true only for administrators
    destroy: -> :admin?
  }
end
```

### Sinatra

```ruby
require "authorize_action"

class Blog < Sinatra::Base
  # Include authorize_action methods
  include AuthorizeAction::Sinatra
  
  # Check action authorization before action.
  # By default all actions are forbidden.
  # Allow requests to `public/` directory if you want.
  before { authorize_action! unless request.path_info.start_with?(settings.public_folder) }
  
  # Everyone has access to reading posts
  get "/posts" do
    # ...
  end
  
  # Only post owner has access to editing post
  get "/posts/:id/edit" do
    # ...
  end
  
  # Only administrator can delete posts
  delete "/posts/:id" do
    # ...
  end
  
  # Authorization rules have to be defined for each route
  # to specify the actual access rules.
  self.authorization_rules = {
    # Calling Proc object for `GET /posts` action returns true
    # thus everyone will have access to that action
    action(:get, "/posts") => -> { true },
    
    # Calling Proc object for `GET /posts/:id/edit` action
    # returns true only when Post owner matches current_user
    action(:get, "/posts/:id/edit") => -> { Post.find(params[:id]).owner == current_user },
    
    # Calling referenced #admin? method for `DELETE /posts/:id` action
    # returns true only for administrators
    action(:delete, "/posts/:id") => :admin?
  }
  
  # Helper method for administrator role
  def admin?
    # ...
  end

end
```

### Other

```ruby
class BaseController
  # Include authorize_action generic methods
  include AuthorizeAction
  
  # Call #authorize_action! before executing any controller actions.
  before_any_action :authorize_action!
  
  private
  
  # Override AuthorizeAction#current_action_name to implement it.
  # It is expected to return a Symbol/String object with an unique
  # controller action identifier.
  def current_action_name
    # ...
  end
  
  # Override AuthorizeAction#forbid_action! to halt execution 
  # of controller action by rendering HTTP 403.
  def forbid_action!
    # ...
  end
  
  # Set authorization rules where keys are in the exact same format
  # as returned by #current_action_name
  # and values are Proc objects returning booleans.
  self.authorization_rules = {
    # ...
  }
end
```

## Tips & Tricks

### Administrator Has Access to Every Action

There is no API for giving access to administrator for every possible action.
Nevertheless it can be achieved easily by just following
object-oriented programming principles.

Example below is based on Rails and Devise, but
the idea is the same for whatever framework:

```ruby
class ApplicationController < ActionController::Base
  include AuthorizeAction::Rails
  
  before_action :authorize_action!
  
  # Override AuthorizeAction#authorize_action! to
  # give access to administrator for every action or
  # fall back to default AuthorizeAction behavior.
  def authorize_action!
    current_user.admin? || super
  end
end
```

Please make sure that you really-really need to do that!

### Protecting Your Views

You have protected your actions with _authorize_action_ and your models with [Strong Parameters](https://github.com/rails/strong_parameters) (or something similar), but what about views?

Again, there is no separate API for that, but why not use regular Ruby methods to do that?

Here's an example:
```ruby
# views/posts/edit.html.erb

<% if current_user.admin? %>
  <%= link_to "Delete", @post, method: :delete %>
<% end %>
```

Next step would be to create some helper class or module for roles.

## License

Copyright (c) Jarmo Pertman (jarmo.p@gmail.com). See [LICENSE](https://github.com/jarmo/authorize_action/blob/master/LICENSE.txt) for details.
