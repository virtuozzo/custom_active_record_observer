require 'spec_helper'

describe CustomActiveRecordObserver do
  let(:schema)  { described_class::Schema.new }
  let(:handler) { -> {} }
  let(:dummy_module) { Module.new }

  def extend_models
    described_class::ModelsExtender.call(schema)
  end

  before do
    described_class.schema = schema

    allow(CustomActiveRecordObserver::ChangesTracker).to receive(:[]).with(:set_depth!).and_return(dummy_module)
  end

  context 'observable model acts as nested set' do
    let!(:dummy_model) do
      class DummyNestedSetModel < ActiveRecord::Base
        acts_as_nested_set
      end
    end

    subject { DummyNestedSetModel.ancestors.first }

    before do
      described_class.observe :DummyNestedSetModel, handler: handler do
        on_create { :created }
      end

      extend_models
    end

    it 'prepends module with overriden #set_depth! method' do
      is_expected.to eq dummy_module
    end
  end

  context 'observable model does not acts as nested set' do
    subject { DummyModel.ancestors }

    before do
      described_class.observe :DummyModel, handler: handler do
        on_create { :created }
      end

      extend_models
    end

    it 'does not prepend module with overriden #set_depth! method' do
      is_expected.not_to include dummy_module
    end
  end
end
