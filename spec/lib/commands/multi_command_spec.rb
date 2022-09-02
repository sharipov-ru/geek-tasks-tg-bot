require './lib/commands/multi_command'
require './lib/commands/base_command'
require './lib/success_result'
require './lib/failure_result'

describe Commands::MultiCommand do
  class TestBaseCommand < Commands::BaseCommand
    def run_command
      raise NotImplementedError
    end

    private

    def success
      SuccessResult.new(text: "#{self.class.name}: ok")
    end

    def failure
      FailureResult.new(text: "#{self.class.name}: fail")
    end
  end

  class TestSuccessfulCommand < TestBaseCommand
    def run_command
      true
    end
  end

  class TestFailureCommand < TestBaseCommand
    def run_command
      raise StandardError
    end
  end

  class TestCommandA < TestSuccessfulCommand; end
  class TestCommandB < TestSuccessfulCommand; end
  class TestCommandC < TestFailureCommand; end

  let(:multi_command) { described_class.new(commands: commands) }

  describe '#execute' do
    subject { multi_command.execute }

    context 'all command executions are successful' do
      let(:commands) { [TestCommandA.new, TestCommandB.new] }

      specify do
        multi_command_result = subject

        executions = multi_command.executions
        expect(executions.size).to eq(2)
        expect(executions.first[:result]).to be_success
        expect(executions.last[:result]).to be_success

        expect(multi_command_result).to be_success
        expect(multi_command_result.text).to eq("TestCommandA: ok\nTestCommandB: ok")
      end
    end

    context 'second command execution fails' do
      let(:commands) { [TestCommandA.new, TestCommandC.new] }

      specify do
        multi_command_result = subject

        executions = multi_command.executions
        expect(executions.size).to eq(2)
        expect(executions.first[:result]).to be_success
        expect(executions.last[:result]).not_to be_success

        expect(multi_command_result).not_to be_success
        expect(multi_command_result.text).to eq("TestCommandA: ok\nTestCommandC: fail")
      end
    end

    context 'first command execution fails' do
      let(:commands) { [TestCommandC.new, TestCommandA.new, TestCommandB.new, ] }

      specify do
        multi_command_result = subject

        executions = multi_command.executions
        expect(executions.size).to eq(1)
        expect(executions.first[:result]).not_to be_success

        expect(multi_command_result).not_to be_success
        expect(multi_command_result.text).to eq('TestCommandC: fail')
      end
    end
  end
end
