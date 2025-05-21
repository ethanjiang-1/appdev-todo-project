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

  def edit
    @group = Group.find(params[:id])
    render template: "groups/edit"
  end

  def update
    @group = Group.find(params[:id])
    @group.name = params.fetch("query_name")
    @group.description = params.fetch("query_description")

    if @group.save
      redirect_to group_path(@group), notice: "Group updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    redirect_to "/groups", notice: "Group deleted successfully."
  end

  def manage_members
    @group = Group.find(params[:id])
    @members = @group.users
    @non_members = User.where.not(id: @members.pluck(:id))
    render template: "groups/members"
  end

  def add_member
    @group = Group.find(params[:id])
    @user_email = params.fetch("query_email")
    if @user_email.present?
      @user = User.find_by(email: @user_email)
      if @user && !GroupMembership.exists?(group: @group, user: @user)
        @role = params.fetch("query_role")
        GroupMembership.create!(group: @group, user: @user, role: @role)
        redirect_to "/groups/#{@group.id}/manage_members"
      else
        redirect_to "/groups/#{@group.id}/manage_members", alert: "User not found or already a member."
      end
      else
        redirect_to "/groups/#{@group.id}/manage_members", alert: "User not found."
    end 
  end

  def remove_member
    @group = Group.find(params[:id])
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      GroupMembership.find_by(group: @group, user: @user)&.destroy
      redirect_to "/groups/#{@group.id}/manage_members", notice: "#{@user.first_name} #{@user.last_name} removed from the group."
    else
      redirect_to "/groups/#{@group.id}/manage_members", alert: "No user specified."
    end
  end
end
