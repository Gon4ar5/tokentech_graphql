require 'spec_helper'

RSpec.describe TokentechGraphql::GraphqlApi::Support::Id do
  describe '.new' do
    specify do
      expect { described_class.new }.to raise_error(NoMethodError)
    end
  end

  describe '.encode' do
    subject(:encode) { described_class.encode(id, gql_type) }

    let(:id)       { 11225 }
    let(:gql_type) { double(graphql_name: 'Dummy') }

    it { is_expected.to eq('VjEsRHVtbXksMTEyMjU') } # "V1,Dummy,11225"
  end

  describe '.decode' do
    subject(:decode) { described_class.decode(input_id, expected_type) }

    let(:input_id)      { 'VjEsRHVtbXksMTEyMjU' } # "V1,Dummy,11225"
    let(:expected_type) { double(graphql_name: 'Dummy') }

    shared_examples 'successfuly decoded' do
      specify do
        expect(decode).to have_attributes(version: 'V1', type: 'Dummy', value: '11225')
      end
    end

    shared_examples 'decoding error' do |message|
      specify do
        expect { decode }.to raise_error(TokentechGraphql::GraphqlApi::Support::Id::DecodingError, message)
      end
    end

    include_examples 'successfuly decoded'

    context 'when expected type is nil' do
      let(:expected_type) { nil }

      include_examples 'successfuly decoded'
    end

    context 'when expected type is a valid type name' do
      let(:expected_type) { 'Dummy' }

      include_examples 'successfuly decoded'
    end

    context 'with different expected type' do
      let(:expected_type) { 'Bar' }

      include_examples 'decoding error', 'unexpected id type "Dummy" (expected "Bar")'
    end

    context 'with invalid input id' do
      let(:input_id) { 11 }

      include_examples 'decoding error', 'invalid input id'
    end

    context 'with invalid base64 for input id' do
      let(:input_id) { '.=' }

      include_examples 'decoding error', 'invalid base64'
    end

    context 'with invalid components count' do
      let(:input_id) { 'VjEsRHVtbXksMTEyMjUseA' } # "V1,Dummy,11225,x"

      include_examples 'decoding error', 'invalid id components count'
    end

    context 'with invalid id version' do
      let(:input_id) { 'VjIsRHVtbXksMTEyMjU' } # "V2,Dummy,11225"

      include_examples 'decoding error', 'invalid id version'
    end

    context 'with invalid id type' do
      let(:input_id) { 'VjEsRHVtK215LDExMjI1' } # "V1,Dum+my,11225"

      include_examples 'decoding error', 'invalid id type'
    end

    context 'with missing id type' do
      let(:input_id) { 'VjEsLDExMjI1' } # "V1,,11225"

      include_examples 'decoding error', 'invalid id type'
    end

    context 'with invalid id value' do
      let(:input_id) { 'VjEsRHVtbXksKw' } # "V1,Dummy,+"

      include_examples 'decoding error', 'invalid id value'
    end

    context 'with blank id value' do
      let(:input_id) { 'VjEsRHVtbXksIA' } # "V1,Dummy, "

      include_examples 'decoding error', 'invalid id value'
    end
  end
end
