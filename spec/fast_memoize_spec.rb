RSpec.describe FastMemoize do
  it "has a version number" do
    expect(FastMemoize::VERSION).not_to be nil
  end

  describe 'the happy path' do
    subject do
      klass = Class.new
      klass.include FastMemoize
      klass.define_method :tabulate, ->{ 120 }
      klass.memoize :tabulate
      klass.new
    end

    it "memoizes a method correctly" do
      expect(subject).to receive(:tabulate).and_call_original
      expect(subject).to receive(:memoized_tabulate).and_call_original
      subject.tabulate
      expect(subject).to receive(:tabulate).and_call_original
      expect(subject).not_to receive(:memoized_tabulate)
      subject.tabulate
    end
  end

  it "throws an error when you try to memoize a method that hasn't been defined yet" do
    expect do
      klass = Class.new
      klass.include FastMemoize
      klass.memoize :tabulate
      klass.define_method :tabulate, ->{ 120 }
    end.to raise_error(FastMemoize::UndefinedMethodError)
  end

  it "throws an error when you try to memoize a method that takes arguments" do
    expect do
      klass = Class.new
      klass.include FastMemoize
      klass.define_method :tabulate, ->(x){ x * 120 }
      klass.memoize :tabulate
    end.to raise_error(FastMemoize::ParameterizedMethodError)
  end
end
