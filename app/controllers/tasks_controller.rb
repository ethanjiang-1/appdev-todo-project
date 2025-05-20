class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    render template: "tasks/index"
  end
end
