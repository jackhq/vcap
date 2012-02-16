require 'spec_helper'

describe "A simple Node app being staged" do
  before do
    app_fixture :node_trivial
  end

  it "is packaged with a startup script" do
    stage :node do |staged_dir|
      executable = '%VCAP_LOCAL_RUNTIME%'
      start_script = File.join(staged_dir, 'startup')
      start_script.should be_executable_file
      script_body = File.read(start_script)
      script_body.should == <<-EXPECTED
#!/bin/bash
cd app && npm rebuild >>../logs/npm.log 2>> ../logs/npm.log && cd ..;
cd app
#{executable} app.js $@ > ../logs/stdout.log 2> ../logs/stderr.log &
STARTED=$!
echo "$STARTED" >> ../run.pid
wait $STARTED
      EXPECTED
    end
  end
end
