require "spec_helper"

describe AuthorizeAction do
  let(:authorizator) { Class.new { include AuthorizeAction }.new }

  context "#authorize_action!" do
    it "forbids action when authorization rules are not defined" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      allow(authorizator).to receive(:authorization_rules).and_return({})
      expect(authorizator).to receive(:forbid_action!)

      authorizator.authorize_action!
    end

    it "forbids action when authorization rule is not defined for current action" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      allow(authorizator).to receive(:authorization_rules).and_return(other_action: -> { false })
      expect(authorizator).to receive(:forbid_action!)

      authorizator.authorize_action!
    end

    it "forbids action when authorization rule returns false" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      allow(authorizator).to receive(:authorization_rules).and_return(action: -> { false })
      expect(authorizator).to receive(:forbid_action!)

      authorizator.authorize_action!
    end

    it "allows action when authorization rule returns true" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      allow(authorizator).to receive(:authorization_rules).and_return(action: -> { true })
      expect(authorizator).to_not receive(:forbid_action!)

      authorizator.authorize_action!
    end

    it "allows action when authorization rule returns truthy value" do
      allow(authorizator).to receive(:current_action_name).and_return(:action)
      allow(authorizator).to receive(:authorization_rules).and_return(action: -> { "truthy" })
      expect(authorizator).to_not receive(:forbid_action!)

      authorizator.authorize_action!
    end
  end

  it "#authorization_rules are empty by default" do
    expect(authorizator.send(:authorization_rules)).to eq({})
  end

  it "#forbid_action! is not implemented by default" do
    expect { authorizator.send(:forbid_action!) }.to raise_error(NotImplementedError)
  end

  it "#current_action_name is not implemented by default" do
    expect { authorizator.send(:current_action_name) }.to raise_error(NotImplementedError)
  end

end
