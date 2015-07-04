require "spec_helper"

describe AuthorizeAction::Rails do
  let(:authorizator) { Class.new { include AuthorizeAction::Rails }.new }

  it "#authorize_action! delegates to AuthorizeAction#authorize_action!" do
    expect_any_instance_of(AuthorizeAction).to receive(:authorize_action!)

    authorizator.authorize_action!
  end

  it "#forbid_action! calls Rails' #head(:forbidden)" do
    expect(authorizator).to receive(:head).with(:forbidden).and_return(:forbidden_result)

    expect(authorizator.send(:forbid_action!)).to eq(:forbidden_result)
  end

  it "#current_action_name calls Rails' #action_name" do
    expect(authorizator).to receive(:action_name).and_return("action-name")

    expect(authorizator.send(:current_action_name)).to eq("action-name".to_sym)
  end
  
end
