class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @personal_tasks = Task.where(listable: current_user).order(:due_date)
    @groups = current_user.groups_joined.order(:name)
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

    listable_type, listable_id = params.fetch("query_listable").split(",")
    @task.listable = listable_type.constantize.find(listable_id)

    @task.creator = current_user

    if @task.save
      redirect_to "/tasks"
    else
      render template: "tasks/new"
    end
  end

  def new
    render template: "tasks/new"
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to "/tasks"
  end

  def edit
    @task = Task.find(params[:id])
    render template: "tasks/edit"
  end

  def update
    @task = Task.find(params[:id])
    @task.title = params.fetch("query_title")
    @task.notes = params.fetch("query_notes")
    @task.due_date = params.fetch("query_due_date")

    listable_type, listable_id = params.fetch("query_listable").split(",")
    @task.listable = listable_type.constantize.find(listable_id)

    if @task.save
      redirect_to "/tasks"
    else
      render template: "tasks/edit"
    end
  end

  def complete
    @task = Task.find(params[:id])
    @task.completed_at = Time.now
    @task.save

    redirect_to "/tasks/#{params[:id]}"
  end

  def incomplete
    @task = Task.find(params[:id])
    @task.completed_at = nil
    @task.save

    redirect_to "/tasks/#{params[:id]}"
  end
end
