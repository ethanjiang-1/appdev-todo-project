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

  #groups
  get "/groups" => "groups#index"
  get "/groups/:id" => "groups#show"
  get "/groups/:group_id/tasks/:task_id" => "tasks#show_group"

end
