require 'spec_helper'

describe CustomActiveRecordObserver do
  let(:schema)  { described_class::Schema.new }
  let(:handler) { -> {} }

  def extend_models
    described_class::ModelsExtender.call(schema)
  end

  before { described_class.schema = schema }

  context 'observable model acts as paranoid' do
    let!(:dummy_model) do
      class DummyParanoidModel < ActiveRecord::Base
        acts_as_paranoid
      end
    end

    let!(:dummy) { DummyParanoidModel.create(name: 'John Doe') }

    before do
      described_class.observe :DummyParanoidModel, handler: handler do
        on_destroy { :destroyed }
      end

      extend_models
    end

    it 'includes CustomActiveRecordObserver::Observable::Paranoid' do
      expect(DummyParanoidModel.ancestors).to include CustomActiveRecordObserver::Observable::Paranoid
    end

    it 'handles paranoid destroy' do
      expect(handler).to receive(:call).with(:destroyed).once

      dummy.destroy
    end
  end
end
