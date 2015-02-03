require 'spec_helper'
require_relative '../../lib/status'

RSpec.describe Status do
  describe 'accessing attributes' do
    context 'accessing a non boolean attributes' do
      subject{ Status.new(foo: 'bar').send(attribute) }

      context 'the attribute is in the hash' do
        let(:attribute){ :foo }
        it{ should eq 'bar' }
      end

      context 'the attribute is NOT in the hash' do
        let(:attribute){ :baz }
        it{ should be_nil  }
      end
    end

    context 'accessing a boolean attributes' do
      Status::BoolFields.each do |attribute|
        context "attribute is #{attribute}" do

          subject{ Status.new(attribute => value).send(attribute) }

          ['true', 'on', '1'].each do |bool_value|
            context "the value set is #{bool_value}" do
              let(:value){ bool_value }
              it { should eq true }
            end
          end

          ['false', 'off', '0', nil, ''].each do |bool_value|
            context "the value set is #{bool_value}" do
              let(:value){ bool_value }
              it { should eq false }
            end
          end
        end
      end

      context 'the value set is not representing a boolean value' do
        it 'raise error' do
          expect do
            Status.new('mean_publication' => 'foo').mean_publication
          end.to raise_error(Status::NotBooleanValueError)
        end
      end
    end
  end
end
