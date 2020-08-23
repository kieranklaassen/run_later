RSpec.describe RunLater do
  it 'has a version number' do
    expect(RunLater::VERSION).not_to be nil
  end

  describe RunLater::Concern do
    subject { User.create(name: 'Arie') }
    it 'defines _later methods for instance_variables' do
      expect(subject).to respond_to(:crash_later)
      expect(subject).to respond_to(:upcase_later)
    end

    describe '#upcase_later' do
      it 'queues the instance method job' do
        expect { subject.upcase_later }.to have_enqueued_job(RunLater::InstanceMethodJob).with(subject, 'upcase!').exactly(:once)
      end
    end

    describe '#crash_later' do
      it 'queues the instance method job' do
        expect { subject.crash_later }.to have_enqueued_job(RunLater::InstanceMethodJob).with(subject, 'crash').exactly(:once)
      end
    end
  end

  describe RunLater::InstanceMethodJob do
    describe '#upcase_later' do
      it 'calls upcase!' do
        user = User.create(name: 'Ben')
        RunLater::InstanceMethodJob.perform_now(user, 'upcase!')
        user.reload
        expect(user).to have_attributes name: 'BEN'
      end
    end

    describe '#crash_later' do
      it 'calls crash' do
        user = User.create(name: 'Ben')
        expect { RunLater::InstanceMethodJob.perform_now(user, 'crash') }.to raise_error(RunLater::Error)
      end
    end
  end
end
