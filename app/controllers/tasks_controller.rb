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

  def show
    @task = Task.find(params[:id])
    render template: "tasks/show"
  end

  def show_group
    @group = Group.find(params[:group_id])
    @task = Task.find(params[:task_id])
    render template: "tasks/show"
  end

  def create
    @task = Task.new
    @task.title = params.fetch("query_title")
    @task.notes = params.fetch("query_notes")
    @task.due_date = params.fetch("query_due_date")

    # Parse listable
    listable_type, listable_id = params.fetch("query_listable").split(",")
    @task.listable = listable_type.constantize.find(listable_id)

    @task.creator = current_user

    if @task.save
      flash[:notice] = "Task created successfully."
      redirect_to "/tasks"
    else
      flash[:alert] = "Failed to create task."
      render template: "tasks/new"
    end
  end

  def new
    render template: "tasks/new"
  end
end
