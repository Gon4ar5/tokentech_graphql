require 'spec_helper'

describe TokentechGraphql::Graphql::Policies::BasePolicy do
  let(:bare_policy_class) { Class.new(described_class) }
  let(:stuffed_policy_class) do
    Class.new(described_class) do
      authorized do
        object.authorized && context[:data].condition
      end

      default_field_authorization do
        object.field_authorized_by_default && context[:data].condition
      end

      public_field :public_data

      authorize_field(:private_data) do
        object.private_data_accessible && context[:data].condition
      end
    end
  end
  let(:dummy_proc) { ->{} }

  describe '.authorized' do
    specify do
      expect { bare_policy_class.authorized(&dummy_proc) }
        .to change(bare_policy_class, :authorized_proc).from(nil).to(dummy_proc)
    end

    it 'raises an error for a subsequent method call' do
      expect { stuffed_policy_class.authorized(&dummy_proc) }
        .to raise_error(ArgumentError, 'Type authorization is already defined')
    end
  end

  describe '.authorize_field' do
    specify do
      expect { bare_policy_class.authorize_field(:private_data, &dummy_proc) }
        .to change { bare_policy_class.field_authorizers[:private_data] }.from(nil).to(dummy_proc)
    end

    it 'raises an error for a subsequent method call' do
      expect { stuffed_policy_class.authorize_field(:private_data, &dummy_proc) }
        .to raise_error(ArgumentError, 'Authorization for `private_data` is already defined')
    end
  end

  describe '.default_field_authorization' do
    specify do
      expect { bare_policy_class.default_field_authorization(&dummy_proc) }
        .to change(bare_policy_class, :default_field_authorization_proc).from(nil).to(dummy_proc)
    end

    it 'raises an error for a subsequent method call' do
      expect { stuffed_policy_class.default_field_authorization {} }
        .to raise_error(ArgumentError, 'Default field authorization is already defined')
    end
  end

  describe '.public_field' do
    specify do
      expect { bare_policy_class.public_field(:public_data) }
        .to change { bare_policy_class.field_authorizers[:public_data] }.from(nil).to(:public)
    end

    it 'raises an error for a subsequent method call' do
      expect { stuffed_policy_class.public_field(:public_data) }
        .to raise_error(ArgumentError, 'Authorization for `public_data` is already defined')
    end
  end

  describe '.field_authorizers' do
    specify do
      expect(stuffed_policy_class.field_authorizers).to match(
        public_data: :public,
        private_data: be_a(Proc)
      )
    end
  end

  describe 'policy object' do
    subject(:policy) { policy_class.new(object, context) }

    let(:policy_class) { stuffed_policy_class }

    let(:object) do
      OpenStruct.new(authorized: true, field_authorized_by_default: true, private_data_accessible: true)
    end
    let(:context) { { data: OpenStruct.new(condition: true) } }

    specify do
      expect(policy.object).to eq(object)
      expect(policy.context).to eq(context)
    end

    describe '#authorized?' do
      subject(:authorized?) { policy.authorized? }

      it { is_expected.to eq(true) }

      context 'when the corresponding proc returns `false`' do
        before { allow(object).to receive(:authorized).and_return(false) }

        it { is_expected.to eq(false) }
      end

      context 'with undefined check proc' do
        let(:policy_class) { bare_policy_class }

        it { is_expected.to eq(true) }
      end
    end

    describe '#field_authorized_by_default?' do
      subject(:field_authorized_by_default?) { policy.field_authorized_by_default? }

      it { is_expected.to eq(true) }

      context 'when the corresponding proc returns `false`' do
        before { allow(object).to receive(:field_authorized_by_default).and_return(false) }

        it { is_expected.to eq(false) }
      end

      context 'with undefined check proc' do
        let(:policy_class) { bare_policy_class }

        it { is_expected.to eq(true) }
      end
    end

    describe '#field_authorized?' do
      specify do
        expect(policy.field_authorized?(:public_data)).to eq(true)
        expect(policy.field_authorized?(:private_data)).to eq(true)
        expect(policy.field_authorized?(:other)).to eq(true)
      end

      context 'when fields are not authorized by default' do
        before { allow(object).to receive(:field_authorized_by_default).and_return(false) }

        specify do
          expect(policy.field_authorized?(:public_data)).to eq(true)
          expect(policy.field_authorized?(:private_data)).to eq(true)
          expect(policy.field_authorized?(:other)).to eq(false)
        end
      end

      context 'with unauthorized private data' do
        before { allow(object).to receive(:private_data_accessible).and_return(false) }

        specify do
          expect(policy.field_authorized?(:public_data)).to eq(true)
          expect(policy.field_authorized?(:private_data)).to eq(false)
          expect(policy.field_authorized?(:other)).to eq(true)
        end
      end
    end
  end
end
