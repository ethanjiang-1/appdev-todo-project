Rails.application.routes.draw do
  devise_for :users

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"

  # personal tasks
  resources :tasks, only: %i[index new create edit update destroy]  

  # group‐scoped tasks + member management
  resources :groups do
    resources :group_memberships, only: %i[index new create edit update destroy]
    resources :tasks, only: %i[index new create edit update destroy], module: :groups
  end

  root "tasks#index"

end
