require 'spec_helper'

describe TokentechGraphql::Graphql::Connections::BaseConnection do
  subject(:connection) { connection_class.new(object, context, arguments) }

  let(:connection_class) { Class.new(described_class) }
  let(:object)           { Class.new }
  let(:context)          { {} }
  let(:arguments)        { nil }

  describe 'pagination' do
    let(:pagination_arg) { { offset: 1, limit: 3 } }
    let(:arguments)      { { pagination: pagination_arg } }

    describe '#pagination' do
      subject(:result) { connection.pagination }

      it { is_expected.to eq(pagination_arg) }

      context 'when arguments are empty' do
        let(:arguments) { {} }

        it { is_expected.to be_nil }
      end

      context 'when arguments are `nil`' do
        let(:arguments) { nil }

        it { is_expected.to be_nil }
      end
    end

    describe '#pagination?' do
      subject(:result) { connection.pagination? }

      it { is_expected.to eq(true) }

      context 'when no pagination argument is passed' do
        let(:arguments) { {} }

        it { is_expected.to eq(false) }
      end

      context 'when arguments are `nil`' do
        let(:arguments) { nil }

        it { is_expected.to eq(false) }
      end
    end
  end

  describe '#filter' do
    subject(:result) { connection.filter }

    let(:filter_arg) { { foo: 'bar' } }
    let(:arguments)  { { filter: filter_arg } }

    it { is_expected.to eq(filter_arg) }

    context 'when no filter argument is passed' do
      let(:arguments) { {} }

      it { is_expected.to eq({}) }
    end

    context 'when arguments are `nil`' do
      let(:arguments) { nil }

      it { is_expected.to eq({}) }
    end
  end

  describe 'order' do
    let(:order_arg) { { field: 'title', direction: 'ASC' } }
    let(:arguments) { { order: order_arg } }

    describe '#order' do
      subject(:result) { connection.order }

      it { is_expected.to eq(order_arg) }

      context 'when arguments are empty' do
        let(:arguments) { {} }

        it { is_expected.to be_nil }
      end

      context 'when arguments are `nil`' do
        let(:arguments) { nil }

        it { is_expected.to be_nil }
      end
    end

    describe '#order?' do
      subject(:result) { connection.order? }

      it { is_expected.to eq(true) }

      context 'when only `field` is passed' do
        let(:arguments) { { field: 1 } }

        it { is_expected.to eq(false) }
      end

      context 'when only `direction` is passed' do
        let(:arguments) { { direction: 1 } }

        it { is_expected.to eq(false) }
      end

      context 'when no order argument is passed' do
        let(:arguments) { {} }

        it { is_expected.to eq(false) }
      end

      context 'when arguments are `nil`' do
        let(:arguments) { nil }

        it { is_expected.to eq(false) }
      end
    end
  end
end
