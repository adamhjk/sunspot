require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'keyword search' do
  before :all do
    Sunspot.remove_all
    @posts = []
    @posts << Post.new(:title => 'The toast elects the insufficient spirit',
                       :body => 'Does the wind write?')
    @posts << Post.new(:title => 'A nail abbreviates the recovering insight outside the moron',
                       :body => 'The interpreted strain scans the buffer around the upper temper')
    @posts << Post.new(:title => 'The toast abbreviates the recovering spirit',
                       :body => 'Does the wind interpret the buffer?')
    Sunspot.index!(*@posts)
    @comment = Namespaced::Comment.new(:body => 'Hey there where ya goin, not exactly knowin, who says you have to call just one place toast.')
    Sunspot.index!(@comment)
  end

  it 'matches a single keyword out of a single field' do
    results = Sunspot.search(Post) { keywords 'toast' }.results
    [0, 2].each { |i| results.should include(@posts[i]) }
    [1].each { |i| results.should_not include(@posts[i]) }
  end

  it 'matches multiple words out of a single field' do
    results = Sunspot.search(Post) { keywords 'elects toast' }.results
    results.should == [@posts[0]]
  end

  it 'matches multiple words in multiple fields' do
    results = Sunspot.search(Post) { keywords 'toast wind' }.results
    [0, 2].each { |i| results.should include(@posts[i]) }
    [1].each { |i| results.should_not include(@posts[i]) }
  end

  it 'matches multiple types' do
    results = Sunspot.search(Post, Namespaced::Comment) do
      keywords 'toast'
    end.results
    [@posts[0], @posts[2], @comment].each  { |obj| results.should include(obj) }
    results.should_not include(@posts[1])
  end
end
