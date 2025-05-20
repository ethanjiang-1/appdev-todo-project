class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = current_user.groups_joined.order(:name)
    render template: "groups/index"
  end

  def show
    @group = Group.find(params[:id])
    render template: "groups/show"
  end

  def new
    @group = Group.new
    render template: "groups/new"
  end

  def create
    @group = Group.new(group_params)
    @group.creator = current_user

    if @group.save
      redirect_to group_path(@group), notice: "Group created successfully."
    else
      render :new
    end
  end
end
