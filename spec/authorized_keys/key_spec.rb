require 'authorized_keys/key'

describe AuthorizedKeys::Key do
  let(:options) do
    %w[
      command="/usr/local/bin/command\ argument"
      no-port-forwarding
      no-X11-forwarding
      no-agent-forwarding
    ]
  end

  let(:options_string) { options.join(',') }

  let(:content) do
    'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzl2OUiWu4GzVdNXBwMCK460uEUZSvuIsccmr15d' +
      'NrwfsHd3CSyTcSea/gMfJL6qFLA9WtM7DUTy6zSzydo3nz5PoFvLZDHV944tkhddGff5JnAAl' +
      'GcoTDsGbAlqSWIfXLJur0jVsaEz9JJ7EbcApv13dkzii0WDE/61OJj2vlhZ/GdlQ6kNE2Zn7M' +
      '1lw0mu8siULhXIxk8QBMZ5tiBVQeHSFq8/BucluOA9eyg38fPSnZxihoQfkC65wDhSy44VsAv' +
      'wLl85eSFF2LJWNGB5NTb5Bfc6OlAWpi0C/XBAskjAeqMmPlBOx6IKwAjdKvbU7Xmuug/tLFu9' +
      'PUKk+nTWExw=='
  end

  let(:comment) do
    "user@host.com - 123"
  end

  let(:key) { [options_string, content, comment].compact.join(" ") }

  subject { AuthorizedKeys::Key.new(key) }

  describe '#initialize' do

    its(:options) { should == options }
    its(:content) { should == content }
    its(:comment) { should == comment }

    its(:to_s)    { should == key }

    context "with bad key content" do
      let(:content) { "blah" }
      it { lambda { subject }.should raise_error("Bad key") }
    end
  end

  describe "#==" do
    it "returns true for keys with the same content" do
      should == AuthorizedKeys::Key.new(content)
    end

    it "returns true for a string that has the same key content" do
      should == content
    end
  end

  describe 'Components' do
    describe '.extract' do
      subject { AuthorizedKeys::Key::Components.extract(key) }

      it { should == [options_string, content, comment] }

      context "with missing options" do
        let(:options) { [] }
        it { should == ["", content, comment] }

        its(:to_s) { should_not =~ /^\s|\s$/ }
      end

      context "with missing comment" do
        let(:comment) { }
        it { should == [options_string, content, ""] }
      end

      context "with missing content" do
        let(:content) { }
        it { should == [] }

        its(:to_s) { should_not =~ /^\s|\s$/ }
      end
    end
  end
end
