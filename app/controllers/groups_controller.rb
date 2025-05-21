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
    @group = Group.new
    @group.creator = current_user
    @group.name = params.fetch("query_name")
    @group.description = params.fetch("query_description")
    @group.creator_id = current_user.id

    if @group.save
      GroupMembership.create!(group: @group, user: current_user, role: :admin)
      redirect_to group_path(@group), notice: "Group created successfully."
    else
      render :new
    end
  end
end
