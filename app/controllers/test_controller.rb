class TestController < ApplicationController

  def index
    render plain: "Hello World! #{DevelopmentIssue.count} no horario #{Time.now}"
  end

end
