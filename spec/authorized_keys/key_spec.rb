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

  context "with RSA key" do
    it { lambda { subject }.should_not raise_error }
  end

  context "with DSS key" do
    let(:content) do
      'ssh-dss AAAAB3NzaC1kc3MAAACBAKzmLlMEKSrOnGIUCV6cU6l56ves14l6gY/6j8B7weZJxW' +
        '84yEBYCXUGxYybV0JfBsQ85nSxRqFKih1xjU9SyRVK3fFggffe30gFT0vDGy/Zj6aOFrF8B2RK' +
        '59VaEyWzZQqKlhtS2M5hBN7JRGKc3haBp+G9fehm42AueAHQBOPXAAAAFQDTBZ3XsR50a3ApSO' +
        'gqF+3JU+Ey6QAAAIEAlT0VLqGgprONWAupcKBOgaYOBLoDdqsXax4E54cn49d/wyi68NU9RJWq' +
        'zNCwpNtFWJJ6SCcJXv5vajBmf2WI8LkaCwq4/oyhRD5QR55uro1zWj0pPA5YN0o7EafYZH1HIO' +
        '+/vM/fbQFd6EGuBbFnortSQgzjHlr8J1UL7f0WbMsAAACAO5A/xv1aQ8uLQQe60VBZRm3pQjb1' +
        'RYB6ZN63Ts/VSw7TNW3/l8+0pqZkarUHXNDxqwSsb9DozgooeZPqM8bpB+t1zM/7f1Be+yaYyu' +
        '3OpaPdceJZGLIcXXbytPw+utRcQPrxucBngukL8TmazZvcfrEONdDS+CK1D/ZqtmjtXPU='
    end

    it { lambda { subject }.should_not raise_error(AuthorizedKeys::BadKeyError) }
  end

  describe '#initialize' do
    its(:options) { should == options }
    its(:content) { should == content }
    its(:comment) { should == comment }

    its(:to_s)    { should == key }

    context "with bad key content" do
      let(:content) { "blah" }
      it { lambda { subject }.should raise_error(AuthorizedKeys::BadKeyError, "Bad key") }

      describe AuthorizedKeys::BadKeyError do
        it "has a reference to the key content" do
          begin
            subject
          rescue => error
            error.key.should == key
          end
        end
      end
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
