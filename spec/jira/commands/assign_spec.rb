require 'spec_helper'

describe Jira::Command::Assign do

  let(:ticket) { 'TA-1000' }
  let(:command) { described_class.new(ticket) }

  let(:api) { double(:api, put: response) }
  let(:response) {
    OpenStruct.new(
      success?: success,
      body:     json
    )
  }
  let(:success) { true }
  let(:json) { {} }

  let(:io) { double(:io, ask: assignee) }
  let(:assignee) { 'assignee' }

  before do
    allow(Jira::Core).to receive(:config) { {} }
    allow(Jira::Core).to receive(:url) { 'https://sample.atlassian.net/' }
    allow(Faraday).to receive(:new) { api }
    allow(command).to receive(:io) { io }
  end

  context 'run' do
    context 'input assignee' do
      it 'sends input assignee as assignee' do
        expect(api).to receive(:put).with(
          "issue/#{ticket}/assignee",
          { name: assignee },
          { 'Content-Type' => 'application/json' }
        )
        expect { command.run }.to output.to_stdout
      end

      context 'success' do
        it 'outputs success message' do
          expect { command.run }.to output(
            /Ticket #{ticket} assigned to '#{assignee}'./
          ).to_stdout
        end
      end

      context 'failure' do
        let(:success) { false }

        context 'error message' do
          let(:json) {
            {
              'errors' => {
                'assignee' => 'Invalid assignee'
              }
            }
          }
          let(:error) { 'Invalid assignee' }

          it 'outputs error message' do
            expect { command.run }.to output(/#{error}/).to_stdout
          end
        end

        context 'no error message' do
          it 'outputs default error message' do
            expect { command.run }.to output(
              /Ticket #{ticket} was not assigned./
            ).to_stdout
          end
        end
      end
    end

    context 'default assignee' do
      let(:assignee) { 'auto' }

      it 'send -1 as assignee' do
        expect(api).to receive(:put).with(
          "issue/#{ticket}/assignee",
          { name: '-1' },
          { 'Content-Type' => 'application/json' }
        )
        expect { command.run }.to output.to_stdout
      end
    end
  end
end
