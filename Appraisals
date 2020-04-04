appraise "4.2.10" do
  gem "rails", "4.2.10"
end

(0..2).each do |version|
  appraise "5.#{version}" do
    gem "rails", "~> 5.#{version}.0"
  end
end

appraise "6.0" do
  gem "rails", "~> 6.0.0"
end
