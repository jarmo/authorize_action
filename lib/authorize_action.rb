module AuthorizeAction
  autoload :Rails, File.expand_path("authorize_action/rails", __dir__)
  autoload :Sinatra, File.expand_path("authorize_action/sinatra", __dir__)

  def authorize_action!
    forbid_action! unless authorization_rules[current_action_name] && authorization_rules[current_action_name].()
  end

  private

  def authorization_rules
    {}
  end

  def forbid_action!
    raise NotImplementedError
  end

  def current_action_name
    raise NotImplementedError
  end
end
