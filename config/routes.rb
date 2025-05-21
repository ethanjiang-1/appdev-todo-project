Rails.application.routes.draw do
  devise_for :users

  # personal tasks
  resources :tasks, only: %i[index new create edit update destroy]  

  # group‐scoped tasks + member management
  resources :groups do
    resources :group_memberships, only: %i[index new create edit update destroy]
    resources :tasks, only: %i[index new create edit update destroy], module: :groups
  end

  root "tasks#index"

  #tasks
  get "/tasks" => "tasks#index"
  get "/tasks/new" => "tasks#new"
  post "/create_task" => "tasks#create"
  get "/tasks/:id" => "tasks#show"
  get "/delete_task/:id" => "tasks#destroy"
  get "/tasks/:id/edit" => "tasks#edit"
  post "/update_task/:id" => "tasks#update"
  post "/tasks/:id/complete" => "tasks#complete"
  post "/tasks/:id/incomplete" => "tasks#incomplete"

  #groups
  get "/groups" => "groups#index"
  get "/groups/:id" => "groups#show"
  get "/groups/:group_id/tasks/:task_id" => "tasks#show_group"
  get "/groups/new" => "groups#new"
  post "/create_group" => "groups#create"
  get "/groups/:id/edit" => "groups#edit"
  post "/update_group/:id" => "groups#update"
  get "/delete_group/:id" => "groups#destroy"
  get "/groups/:id/manage_members" => "groups#manage_members"
  post "/groups/:id/add_member" => "groups#add_member"
  post "/groups/:id/remove_member" => "groups#remove_member"

end
