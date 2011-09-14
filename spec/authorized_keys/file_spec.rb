require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'authorized_keys/file'

describe AuthorizedKeys::File do
  let(:home) { "/home/user" }

  before(:all) do
    @backup_home = ENV['HOME']
    ENV['HOME'] = home
  end

  after(:all) { ENV['HOME'] = @backup_home }

  context "with no file location specified" do
    subject { AuthorizedKeys::File.new }

    it "defaults to $HOME/.ssh/authorized_keys" do
      subject.location.should == "#{home}/.ssh/authorized_keys"
    end
  end
end
