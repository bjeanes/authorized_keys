require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'authorized_keys/file'
require 'tempfile'

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

  context do
    let(:file)    { Tempfile.new('authorized_keys') }
    before(:each) { file.close } # Close so our class can modify it
    after(:each)  { file.close } # Close after we check it for convenience

    subject { AuthorizedKeys::File.new(file.path) }

    context "with file location specified" do
      its(:location) { should == file.path }
    end

    describe "#add" do
      it "adds a valid key to the file" do
        key = fixture_key(1)
        subject.add(key)

        file.open
        file.rewind
        file.read.should == key
      end

      it "raises an exception for a bad key" do
        lambda { subject.add("foo bar") }.should raise_error "Bad key"
      end
    end

    describe "#remove" do

    end
  end
end
