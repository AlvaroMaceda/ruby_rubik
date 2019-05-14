require 'rspec'
require './src/permutation.rb'

describe 'Permutation' do

  it 'creates the class' do
    p = Permutation.new({})
    expect(p).to be_kind_of(Permutation)
  end

  it 'must be biyective' do
    # injective: F(x)=F(y)⟹x=y

    # This is not inyective: there are two elements with the same image
    expect {
      Permutation.new(
          {
              :a => :b,
              :b => :c,
              :c => :c,
              :d => :b
          }
      )
    }.to raise_error RuntimeError

    # This should fail because F(c)=c and F(b)=c, too (c will remain unchanged)
    # and element :a won't have an image (the function won't be surjective)
    expect {
      Permutation.new(
          {
              :a => :b,
              :b => :c
          }
      )
    }.to raise_error RuntimeError
  end


  it 'applies a permutation with all elements present' do
    p = Permutation.new({
                            :a => :b,
                            :b => :c,
                            :c => :a
                        })
    original_set = [:a,:b,:c]
    expected_result = [:b,:c,:a]

    result = p.apply_to(original_set)
    expect(result).to eq(expected_result)

    p = Permutation.new({
                            :a => :c,
                            :c => :a,
                            :j => :k,
                            :k => :j
                        })
    original_set = [:b,:c,:a]
    expected_result = [:b,:a,:c]
    result = p.apply_to(original_set)
    expect(result).to eq(expected_result)

  end

  it 'calculates the inverse' do
    # The inverse of a permutation applied after or before the permutation is the identity permutation
    p = Permutation.new({
                              :a => :b,
                              :b => :c,
                              :c => :a
                          })
    original_set = [:c,:b,:a, :d, :j]

    original_applied = p.apply_to(original_set)
    both_applied = (!p).apply_to(original_applied)
    expect(both_applied).to eql(original_set)

    inverse_applied = (!p).apply_to(original_set)
    both_applied = p.apply_to(inverse_applied)
    expect(both_applied).to eql(original_set)
  end

  it 'pipes with another permutation' do
    p1 = Permutation.new({
                             :a => :b,
                             :b => :c,
                             :c => :a
                         })
    p2 = Permutation.new({
                             :a => :c,
                             :c => :a
                         })
    expected_product = Permutation.new({
        :a => :b,
        :b => :a
    })

    p12 = p1*p2
    expect(p12).to eql(expected_product)

  end

  it 'has an identity pemutation' do
    p1 = Permutation.new({
                             :a => :b,
                             :b => :c,
                             :c => :a
                         })
    identity = Permutation::IDENTITY

    p2 = p1 * identity
    expect(p2).to eql(p1)

    p2 = identity * p1
    expect(p2).to eql(p1)
  end

  xit 'is associative' do
  end

  it 'obtains the cycle form' do

    p = Permutation.new({
                            :a => :b,
                            :b => :c,
                            :c => :a
                        })
    expected_cycles = [
        [:a, :b, :c]
    ]
    # TODO: there are other posible valid cycles:
    # [:b, :c, :a]
    # [:c, :b, :a]
    # We need a custom expectation to check for "rotations"
    # of an array and give them as valid
    #
    expect(p.cycles).to eql(expected_cycles)


    p = Permutation.new({
                            :a => :b,
                            :b => :a,
                            :c => :e,
                            :d => :c,
                            :e => :d
                        })
    expected_cycles = [
        [:a,:b],[:c, :e, :d]
    ]
    # TODO: the order of cycles should be no relevant
    # We must check not for equality, but for same elements in the same
    # "cyclic order". We would need a custom expectation.

    expect(p.cycles).to eql(expected_cycles)

  end

end