require 'spec_helper'

describe Table do
  subject { Table.new(4, 5).falling?(*position) }

  describe '#falling?' do
    context 'top left corner' do
      let(:position) { [0, 0] }
      it { is_expected.to be_falsy }
    end

    context 'bottom right corner' do
      let(:position) { [3, 4] }
      it { is_expected.to be_falsy }
    end

    context 'falling on right' do
      let(:position) { [4, 4] }
      it { is_expected.to be_truthy }
    end

    context 'falling below bottom' do
      let(:position) { [2, 5] }
      it { is_expected.to be_truthy }
    end
  end
end

describe Robot do
  let(:robot) { Robot.new(Table.new(5, 5)) }

  context 'it is not placed' do
    it "should raise NotPlacedError for MOVE command" do
      expect { robot.move_cmd }.to raise_error(NotPlacedError)
    end

    it "should raise NotPlacedError for LEFT command" do
      expect { robot.left_cmd }.to raise_error(NotPlacedError)
    end

    it "should raise NotPlacedError for RIGHT command" do
      expect { robot.right_cmd }.to raise_error(NotPlacedError)
    end

    it "should raise NotPlacedError for REPORT command" do
      expect { robot.report_cmd }.to raise_error(NotPlacedError)
    end
  end

  it "should be placed correctly" do
    expect(robot.place_cmd(0, 0, :south).report_cmd).to eq([0, 0, "SOUTH"])
  end

  it "should ignore commands if it's not on table" do
    expect{robot.right_cmd}.to raise_error(NotPlacedError)
    expect(robot.place_cmd(0, 0, :south).report_cmd).to eq([0, 0, "SOUTH"])
  end

  it "should ignore invalid PLACE command: CASE 1" do
    expect{robot.place_cmd(5, 4, :north)}.to raise_error(FallingError)
  end

  it "should ignore invalid PLACE command: CASE 2" do
    expect(robot.place_cmd(0, 0, :south).report_cmd).to eq([0, 0, "SOUTH"])
    expect{robot.place_cmd(5, 4, :north)}.to raise_error(FallingError)
    expect(robot.report_cmd).to eq([0, 0, "SOUTH"])
  end
  
  it "should MOVE correctly after it's placed" do
    expect(robot.place_cmd(0, 0, :north).move_cmd.report_cmd).to eq([0, 1, 'NORTH'])
  end

  it "should ignore MOVE which cause falling" do
    expect{robot.place_cmd(4, 4, :north).move_cmd}.to raise_error(FallingError)
    expect(robot.report_cmd).to eq([4, 4, "NORTH"])
  end

  it "should report correctly after several commands: CASE 1" do
    expect(robot.place_cmd(0, 0, :north).move_cmd.report_cmd).to eq([0, 1, "NORTH"])
  end

  it "should report correctly after several commands: CASE 2" do
    expect(robot.place_cmd(0, 0, :north).left_cmd.report_cmd).to eq([0, 0, "WEST"])
  end

  it "should report correctly after several commands: CASE 3" do
    expect(robot.place_cmd(1, 2, :east).move_cmd.move_cmd.left_cmd.move_cmd.report_cmd).to eq([3, 3, "NORTH"])
  end
end
