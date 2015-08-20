require 'spec_helper'

describe Poll do
  context 'validation' do
    %i(title user status).each do |key|
      it { should validate_presence_of(key) }
    end

    it { should validate_uniqueness_of(:title) }

    it do
      valid_statuses = %i(draft open closed)
      should validate_inclusion_of(:status).in_array(valid_statuses)
    end
  end

  context 'when new status' do
    subject { create(:poll) }

    context 'open' do
      before(:each) do
        subject.status = :open
        subject.open_date = nil
        subject.close_date = Time.now
      end

      it 'set open date' do
        expect { subject.save }.to change(subject, :open_date)
      end

      it "doesn't change close date" do
        expect { subject.save }.not_to change(subject, :close_date)
      end
    end

    context 'closed' do
      before(:each) do
        subject.status = :closed
        subject.open_date = Time.now
        subject.close_date = nil
      end

      it 'set close date' do
        expect { subject.save }.to change(subject, :close_date)
      end

      it "doesn't change open date" do
        expect { subject.save }.not_to change(subject, :open_date)
      end
    end
  end
end
