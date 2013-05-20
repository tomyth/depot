# Load the rails application.
require File.expand_path('../application', __FILE__)

Rails.logger = ActiveSupport::Logger.new STDOUT
# Rails.logger.level = 0
# Initialize the rails application.
Depot::Application.initialize!
