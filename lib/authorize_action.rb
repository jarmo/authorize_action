module AuthorizeAction
  autoload :Rails, File.expand_path("authorize_action/rails", __dir__)
  autoload :Sinatra, File.expand_path("authorize_action/sinatra", __dir__)

  def authorize_action!
    authorization_rule = self.class.authorization_rules && self.class.authorization_rules[current_action_name]
    action_permitted = authorization_rule && instance_exec(&authorization_rule)
    forbid_action! unless action_permitted
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_accessor :authorization_rules
  end

  private

  def forbid_action!
    raise NotImplementedError
  end

  def current_action_name
    raise NotImplementedError
  end
end
