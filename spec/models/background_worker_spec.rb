require 'spec_helper'

describe BackgroundWorker do

  context "validation" do 
    subject {BackgroundWorker.create({:task_name => "test.file"})}

    specify {subject.should be_valid}
    specify {subject.current_status.should == "preparation"}
    specify {subject.task_name.should == "test.file"}
  end
  
  context "status_values" do
    it 'status value should only from list' do
      bw = BackgroundWorker.create({:task_name => "test.file"})
      bw.current_status = "zzz"
      bw.should_not be_valid
      bw.should have(1).error_on(:current_status)
    end
  end
end
