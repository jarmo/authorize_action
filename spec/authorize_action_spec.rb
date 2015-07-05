require "spec_helper"

describe AuthorizeAction do
  let(:authorizator) { Class.new { include AuthorizeAction }.new }

  context "#authorize_action!" do
    it "forbids action when authorization rules are not defined" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      expect(authorizator).to receive(:forbid_action!)

      authorizator.class.authorization_rules = nil
      authorizator.authorize_action!
    end

    it "forbids action when authorization rules are empty" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      expect(authorizator).to receive(:forbid_action!)

      authorizator.class.authorization_rules = {}
      authorizator.authorize_action!
    end

    it "forbids action when authorization rule is not defined for current action" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      expect(authorizator).to receive(:forbid_action!)

      authorizator.class.authorization_rules = {other_action: -> { false }}
      authorizator.authorize_action!
    end

    it "forbids action when authorization rule returns false" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      expect(authorizator).to receive(:forbid_action!)

      authorizator.class.authorization_rules = {action: -> { false }}
      authorizator.authorize_action!
    end

    it "allows action when authorization rule returns true" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      expect(authorizator).to_not receive(:forbid_action!)

      authorizator.class.authorization_rules = {action: -> { true }}
      authorizator.authorize_action!
    end

    it "allows action when authorization rule returns truthy value" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      expect(authorizator).to_not receive(:forbid_action!)

      authorizator.class.authorization_rules = {action: -> { "truthy" }}
      authorizator.authorize_action!
    end
  end

  it "#authorization_rules are not defined by default" do
    expect(authorizator.class.authorization_rules).to be_nil
  end

  it "#forbid_action! is not implemented by default" do
    expect { authorizator.send(:forbid_action!) }.to raise_error(NotImplementedError)
  end

  it "#current_action_name is not implemented by default" do
    expect { authorizator.send(:current_action_name) }.to raise_error(NotImplementedError)
  end

end
