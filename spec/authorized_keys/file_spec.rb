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

      it "appends the key to any existing keys" do
        key1, key2 = fixture_key(1), fixture_key(2)

        file.open
        file.write(key1)
        file.close

        subject.add(key2)

        file.open
        file.rewind
        file.read.should == [key1, key2].join("")
      end

      it "raises an exception for a bad key" do
        lambda { subject.add("foo bar") }.should raise_error(AuthorizedKeys::BadKeyError, "Bad key")
      end
    end

    describe "#remove" do
      it "deletes the key from the file" do
        key1, key2 = fixture_key(1), fixture_key(2)

        file.open
        file.puts [key1, key2]
        file.close

        subject.remove(key1)

        new_file = File.open(file.path, 'r') # Need to get new handle
        new_file.read.should == key2
        new_file.close
      end
    end
    describe "#keys" do
      it "get the keys from the file" do
        key1, key2 = fixture_key(1), fixture_key(2)

        file.open
        file.puts [key1, key2]
        file.close
        subject.keys.size.should eq 2
      end
    end
  end
end
