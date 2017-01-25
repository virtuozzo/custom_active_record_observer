require 'spec_helper'

# look at spec/dummy/config/initializers/custom_active_record_observer.rb for configuration
describe CustomActiveRecordObserver do
  let(:handler) { DummyHandler }

  def dummy_model(params = {})
    DummyModel.new(params)
  end

  describe '.handle' do
    context 'create' do
      it 'handles if model was created' do
        expect(handler).to receive(:call).with(handler::CREATED)

        dummy_model.save
      end
    end

    context 'update' do
      let(:name) { 'Name' }

      it 'is handled if attribute changed from nil to some value' do
        model = dummy_model.tap(&:save)

        expect(handler).to receive(:call).with(handler::ADDED)

        model.update_attributes(name: name)
      end

      it 'is handled if attributes was set to nil' do
        model = dummy_model(name: name).tap(&:save)

        expect(handler).to receive(:call).with(handler::REMOVED)

        model.update_attributes(name: nil)
      end

      it 'is handled if attributes was changed from some not nil value to other value' do
        model = dummy_model(name: name).tap(&:save)

        expect(handler).to receive(:call).with(handler::CHANGED)

        model.update_attributes(name: "New #{name}")
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
      it 'is handled' do
        model = dummy_model.tap(&:save)

        expect(handler).to receive(:call).with(handler::DELETED)

        model.destroy
      end
    end
  end
end
