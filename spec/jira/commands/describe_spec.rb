require 'spec_helper'

describe Jira::Command::Describe do
  let(:ticket) { 'TA-1000' }
  let(:command) { described_class.new(ticket) }
  let(:api) { double('api', get: json) }

  before do
    allow(Jira::API).to receive(:new) { api }
  end

  context 'run' do
    context 'empty json' do
      let(:json) { { } }

      it 'outputs nothing' do
        expect { command.run }.not_to output.to_stdout
      end
    end

    context 'successful' do
      let(:json) {
        {
          'fields' => {
            'assignee' => {
              'name' => assignee
            },
            'status' => {
              'name' => status
            },
            'summary' => summary
          }
        }
      }
      let(:assignee) { 'assignee' }
      let(:status) { 'status' }
      let(:summary) { 'summary' }

      context 'assignee' do
        it 'outputs assignee' do
          expect { command.run }.to output(/#{assignee}/).to_stdout
        end

        context 'unset' do
          let(:assignee) { nil }

          it 'outputs unassigned' do
            expect { command.run }.to output(/Unassigned/).to_stdout
          end
        end
      end

      context 'status' do
        it 'outputs status' do
          expect { command.run }.to output(/#{status}/).to_stdout
        end

        context 'unset' do
          let(:status) { nil }

          it 'outputs unknown' do
            expect { command.run }.to output(/Unknown/).to_stdout
          end
        end
      end

      context 'summary' do
        it 'outputs summary' do
          expect { command.run }.to output(/#{summary}/).to_stdout
        end

        context 'long summary' do
          let(:summary) {
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do'\
            ' eiusmod tempor incididunt ut labore et dolore magna aliqua.'
          }
          let(:truncated) {
            'Lorem ipsum dolor sit amet, consectetur adi...'
          }

          it 'is truncated' do
            expect { command.run }.to output(/#{truncated}/).to_stdout
          end
        end
      end
    end
  end
end
