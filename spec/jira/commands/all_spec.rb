require 'spec_helper'

describe Jira::Command::All do
  let(:command) { described_class.new }
  let(:api) { double('api', get: json) }
  let(:branches) { [] }
  let(:json) { {} }

  before do
    allow(Jira::API).to receive(:new) { api }
    allow(command).to receive(:branches) { branches }
  end

  context 'run' do
    context 'no tickets' do
      it 'outputs notice' do
        expect { command.run }.to output(/No tickets/).to_stdout
      end
    end

    context 'tickets' do
      let(:branches) { [ branch ] }
      let(:branch) { 'TA-1000' }

      it 'queries correct endpoint' do
        expect(api).to receive(:get).with(
          'search',
          params: {
            jql: "key in (#{branch})"
          }
        )
        command.run
      end

      context 'no json' do
        it 'outputs nothing' do
          expect { command.run }.not_to output.to_stdout
        end
      end

      context 'no errors' do
        let(:json) {
          {
            'issues' => [
              {
                'key' => branch,
                'fields' => {
                  'summary' => summary,
                  'assignee' => {
                    'name' => assignee
                  },
                  'status' => {
                    'name' => status
                  }
                }
              }
            ]
          }
        }
        let(:summary) { 'summary' }
        let(:assignee) { 'assignee' }
        let(:status) { 'status' }

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

end
