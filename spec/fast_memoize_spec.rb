RSpec.describe FastMemoize do
  it "has a version number" do
    expect(FastMemoize::VERSION).not_to be nil
  end

  describe 'memoize public method' do
    subject do
      class Part
        include FastMemoize
        def tabulate
          120
        end
        memoize :tabulate
      end
      Part.new
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

  describe 'memoize private method' do
    subject do
      class BitPart
        include FastMemoize
        def tabulate
          private_tabulate
        end
        private
        def private_tabulate
          144
        end
        memoize :private_tabulate
      end
      BitPart.new
    end

    it "memoizes a method correctly" do
      expect(subject).to receive(:private_tabulate).and_call_original
      expect(subject).to receive(:memoized_private_tabulate).and_call_original
      subject.tabulate
      expect(subject).to receive(:private_tabulate).and_call_original
      expect(subject).not_to receive(:memoized_private_tabulate)
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

  it "throws an error when you try to memoize a public method that takes arguments" do
    expect do
      klass = Class.new
      klass.include FastMemoize
      klass.define_method :tabulate, ->(x){ x * 120 }
      klass.memoize :tabulate
    end.to raise_error(FastMemoize::ParameterizedMethodError)
  end

  it "throws an error when you try to memoize a private method that takes arguments" do
    expect do
      class StranglyPrivate
        include FastMemoize
        private
        def multiply(x, y)
          x * y
        end
        memoize :multiply
      end
    end.to raise_error(FastMemoize::ParameterizedMethodError)
  end
end
