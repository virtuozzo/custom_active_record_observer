require 'spec_helper'

describe CustomActiveRecordObserver do
  let(:handler) { ->(action) {} }
  let(:sub_handler) { ->(action) {} }
  let(:schema) { described_class::Schema.new }
  let(:name) { 'Name' }

  def dummy_model(params = {})
    DummyModel.new(params)
  end

  def dummy_submodel(params = {})
    DummySubModel.new(params)
  end

  def extend_models
    described_class::ModelsExtender.call(schema)
  end

  before { described_class.schema = schema }

  context 'create' do
    before do
      described_class.observe :DummyModel, handler: handler do
        on_create { :created_1 }
      end

      described_class.observe :DummySubModel, :DummyModel, handler: sub_handler do
        on_create { :created_2 }
      end

      extend_models
    end

    it 'handles if model was created' do
      expect(handler).to receive(:call).with(:created_1)

      dummy_model.save
    end

    it 'does not duplicate handler operation in parent class' do
      expect(sub_handler).to receive(:call).with(:created_2).exactly(1).times

      dummy_model.save
    end

    it 'does not duplicate handler operation in parent class' do
      expect(sub_handler).to receive(:call).with(:created_2).exactly(1).times

      dummy_submodel.save
    end
  end

  context 'update' do
    before do
      described_class.observe :DummyModel, handler: handler do
        on_update(:name)                   { :updated }
        on_update(:name, [nil, String])    { :updated_from_nil_to_string }
        on_update(:name, [nil, 'MyName'])  { :updated_from_nil_to_my_name }
        on_update(:name, [String, nil])    { :updated_from_string_to_nil }
        on_update(:name, [String, String]) { :updated_from_string_to_string }
      end

      extend_models
    end

    it 'is handled if attribute changed from nil to some value' do
      model = dummy_model.tap(&:save)

      expect(handler).to receive(:call).with(:updated)
      expect(handler).to receive(:call).with(:updated_from_nil_to_string)

      model.update_attributes(name: name)
    end

    it 'is handled if attributes was set to nil' do
      model = dummy_model(name: name).tap(&:save)

      expect(handler).to receive(:call).with(:updated)
      expect(handler).to receive(:call).with(:updated_from_string_to_nil)

      model.update_attributes(name: nil)
    end

    it 'is handled if attributes was changed from some not nil value to other value' do
      model = dummy_model(name: name).tap(&:save)

      expect(handler).to receive(:call).with(:updated)
      expect(handler).to receive(:call).with(:updated_from_string_to_string)

      model.update_attributes(name: "New #{name}")
    end

    it 'is handled if attributes was changed to some particular value' do
      model = dummy_model(name: nil).tap(&:save)

      expect(handler).to receive(:call).with(:updated)
      expect(handler).to receive(:call).with(:updated_from_nil_to_string)
      expect(handler).to receive(:call).with(:updated_from_nil_to_my_name)

      model.update_attributes(name: 'MyName')
    end

    it 'is not handled if some other attribute was changed' do
      model = dummy_model(name: name, age: 10).tap(&:save)

      expect(handler).not_to receive(:call)

      model.name = name
      model.age = 16
      model.save!
    end
  end

  context 'destroy' do
    before do
      described_class.observe :DummyModel, handler: handler do
        on_destroy { :destroyed }
      end

      extend_models
    end

    it 'is handled' do
      expect(handler).to receive(:call).with(:destroyed)

      dummy_model.tap(&:save).destroy
    end
  end

  describe '.on_remove' do
    before do
      described_class.observe :DummyModel, handler: handler do
        on_remove(:name) { :removed }
      end

      extend_models
    end

    it 'handles nils' do
      expect(handler).to receive(:call).with(:removed)

      dummy_model(name: name).tap(&:save).update_attributes(name: nil)
    end

    it 'does not handle other changes' do
      expect(handler).not_to receive(:call)

      dummy_model(name: name).tap(&:save).update_attributes(name: 'Name 2')
    end
  end

   describe '.on_add' do
    before do
      described_class.observe :DummyModel, handler: handler do
        on_add(:name) { :added }
      end

      extend_models
    end

    it 'handles nils' do
      expect(handler).to receive(:call).with(:added)

      dummy_model(name: nil).tap(&:save).update_attributes(name: name)
    end

    it 'does not handle other changes' do
      expect(handler).not_to receive(:call)

      dummy_model(name: name).tap(&:save).update_attributes(name: 'Name 2')
    end
  end

  describe '.on_change' do
    before do
      described_class.observe :DummyModel, handler: handler do
        on_change(:name) { :changed }
      end

      extend_models
    end

    it 'handles not nil changes' do
      expect(handler).to receive(:call).with(:changed)

      dummy_model(name: name).tap(&:save).update_attributes(name: 'Name 2')
    end

    it 'does not handle nil changes' do
      expect(handler).not_to receive(:call)

      dummy_model(name: nil).tap(&:save).update_attributes(name: name)
    end

    it 'does not handle nil changes' do
      expect(handler).not_to receive(:call)

      dummy_model(name: name).tap(&:save).update_attributes(name: nil)
    end
  end
end
