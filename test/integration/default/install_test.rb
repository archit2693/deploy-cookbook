describe port(80), :skip do
  it { should_not be_listening }
end
