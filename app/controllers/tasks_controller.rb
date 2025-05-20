class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    # Personal tasks: tasks where listable is the current user
    @personal_tasks = Task.where(listable: current_user).order(:due_date)

    # Groups the user belongs to
    @groups = current_user.groups_joined.order(:name)

    # Group tasks: tasks where listable is a group the user is a member of
    @group_tasks = Task.where(listable: @groups).includes(listable: :creator).order(:due_date)

    render template: "tasks/index"
  end
end
