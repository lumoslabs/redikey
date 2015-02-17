require 'spec_helper'

module Redikey
  describe KeyHelper do
    let(:user_id) { 999 }
    let(:prefixes) { [] }
    let(:redikey) { described_class.new(user_id, prefixes: prefixes) }

    describe '#key' do

      subject { redikey.key }

      context 'without a prefix' do
        it 'returns the sharded key' do
          expect(subject).to eq( sharded_key )
        end
      end

      context 'with a prefix' do
        let(:prefixes) { [:foo, :bar] }

        it 'returns the sharded key with a prefix' do
          expect(subject).to eq( "foo:bar:#{sharded_key}"  )
        end

        context 'with additional prefix' do
          subject { redikey.key('baz') }

          it 'appends the additional prefix to the key' do
            expect(subject).to eq("foo:bar:baz:#{sharded_key}")
          end
        end
      end

      context 'with additional prefix' do
        subject { redikey.key('baz') }

        it 'appends the additional prefix to the key' do
          expect(subject).to eq("baz:#{sharded_key}")
        end
      end

      context 'when separator is /' do
        let(:redikey) { described_class.new(user_id, separator: '/', prefixes: prefixes) }
        let(:prefixes) { [:foo, :bar] }

        it 'uses the given separator' do
          expect(subject).to eq("foo/bar/#{sharded_key}")
        end
      end
    end

    describe '#field_key' do
      subject { redikey.field_key }

      it 'returns the resource key, mod the default hash size' do
        expect(subject).to eq( sharded_field_key )
      end
    end

    def sharded_key
      (user_id / described_class::DEFAULT_HASH_SIZE).to_s
    end

    def sharded_field_key
      user_id % described_class::DEFAULT_HASH_SIZE
    end
  end
end
