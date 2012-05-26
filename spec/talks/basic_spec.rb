OPTS_INITFILE = 'spec/test_data/talksrc'
require 'talks'

describe Talks do

  it 'should have default methods' do
    [:add_hooks, :info, :error, :success, :warn, :say, :config].each do |method|
      Talks.methods.include?(method).should be_true
    end
  end

  describe '#config' do

    it 'should load initfile' do
      Talks.config.options.should_not be_empty
    end

    it 'should load default values from initfile' do
      Talks.config.default_voice.should == 'agnes'
    end

    it 'should contain default values for voices and messages' do
      Talks.config.voices.keys.should_not be_empty
      Talks.config.messages.keys.should_not be_empty
    end

    it 'should return voice for type' do
      Talks.config.voice(:info).should == 'vicki'
    end

    it 'should return message for type' do
      Talks.config.message(:info).should == 'Information note'
    end

    it 'should return message for command if it is in .talksrc' do
      Talks.config.message_for(:bundle, :before).should == 'Bundle before message'
      Talks.config.message_for(:bundle, :after).should == 'Bundle after message'
    end

    it 'should return voice for command if it is in .talksrc' do
      Talks.config.voice_for(:bundle).should == 'bad'
    end

    it 'should return default message for command' do
      Talks.config.default_message_for(:bundle, :before).should == 'bundle task started'
      Talks.config.default_message_for(:bundle, :after).should == 'bundle task ended'
    end

  end

  context 'hooks' do

    it 'should create hooks for any command by default' do
      Talks.add_hooks(['ls']).should == "say -v agnes 'ls task started'; ls; say -v agnes 'ls task ended'"
    end

    it 'should create preconfigured hooks for command from .talksrc' do
      Talks.add_hooks(['bundle']).should == "say -v bad 'Bundle before message'; bundle; say -v bad 'Bundle after message'"
    end

    it 'should change voice if option sended' do
      Talks.add_hooks(['-v', 'vicki', 'ls']).should == "say -v vicki 'ls task started'; ls; say -v vicki 'ls task ended'"
    end

    it 'should change messages if option sended' do
      Talks.add_hooks(['-bm', 'test', 'ls']).should == "say -v agnes 'test'; ls; say -v agnes 'ls task ended'"
      Talks.add_hooks(['-am', 'test', 'ls']).should == "say -v agnes 'ls task started'; ls; say -v agnes 'test'"
    end

    it 'should create hooks for command inside `bundle exec` by default' do
      Talks.add_hooks(['bundle', 'exec', 'ls']).should == "say -v agnes 'ls task started'; bundle exec ls; say -v agnes 'ls task ended'"
    end

  end

end
