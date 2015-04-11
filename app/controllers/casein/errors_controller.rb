class Casein::ErrorsController < Casein::CaseinController
  before_filter :authorise, :except => [:file_not_found, :unprocessable, :internal_server_error]
  def file_not_found
  end

  def unprocessable
  end

  def internal_server_error
  end
end
