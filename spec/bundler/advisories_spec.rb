require_relative '../spec_helper'

describe Advisories do
  context 'defaults' do
    it 'should default to home dir' do
      Advisories.new.dir.should == File.expand_path('~/.ruby-advisory-db')
    end

    it 'should default to rubysec ruby-advisory-db' do
      Advisories.new.repo.should == 'git@github.com:rubysec/ruby-advisory-db.git'
    end
  end

  context 'test setup' do
    before do
      @a = Advisories.new(
        dir: File.join(Dir.tmpdir, '.ruby-advisory-db'),
        repo: 'git@github.com:chrismo/bundler-advise.git'
      )
    end

    after do
      FileUtils.rmtree @a.dir
    end

    it 'should clone if no copy exists' do
      File.exist?(@a.dir).should_not be true
      @a.update
      File.exist?(@a.dir).should be true
      File.exist?(File.join(@a.dir, '.git')).should be true
    end

    it 'should pull if working dir exists' do
      File.exist?(@a.dir).should_not be true
      @a.update
      File.exist?(File.join(@a.dir, '.git')).should be true
      @a.update
    end

    it 'should error handle messed up dir' do
      FileUtils.makedirs @a.dir
      lambda { @a.update }.should raise_error(/problem with working dir/)
    end

    it 'should clean update a messed up dir' do
      FileUtils.makedirs @a.dir
      @a.clean_update!
      File.exist?(File.join(@a.dir, '.git')).should be true
    end
  end
end