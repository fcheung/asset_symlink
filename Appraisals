appraise "4.2.10" do
  gem "rails", "4.2.10"
end

(0..1).each do |version|
  appraise "5.#{version}" do
    gem "rails", "~> 5.#{version}.0"
  end
end
