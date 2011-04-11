require 'spec_helper'

describe BackgroundWorker do


 subject {BackgroundWorker.create({:task_name => "test.file"})}
  
  specify {subject.should be_valid}
  specify {subject.current_status.should == "preparation"}
  specify {subject.task_name.should == "test.file"}
end
