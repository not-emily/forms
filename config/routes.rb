Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "welcome#index"

  #
  # WELCOME 
  #
  get '/sign-in', to: "welcome#signin", as: :signin
  post '/sign-in', to: "welcome#signin_do", as: :do_signin
  get '/sign-up', to: "welcome#signup", as: :signup
  post '/sign-up', to: "welcome#signup_do", as: :do_signup
  get '/signout', to: "welcome#signout", as: :signout

  #
  # ACCOUNTS 
  #
  get '/accounts', to: "accounts#select_accounts", as: :select_accounts
  get '/accounts/:id', to: "accounts#select_accounts_do", as: :do_select_accounts

  #
  # PROJECTS 
  #
  get '/projects', to: "projects#index", as: :projects
  get '/projects/:project_apikey', to: "projects#show", as: :show_project

  #
  # FORMS
  #
  get '/projects/:project_apikey/new', to: "custom_forms#new", as: :new_form
  post '/projects/:project_apikey/new', to: "custom_forms#create", as: :create_form
  get '/projects/:project_apikey/:form_apikey', to: "custom_forms#show", as: :show_form
  
  # FORM FIELDS
  get '/projects/:project_apikey/:form_apikey/new-form-field', to: "custom_forms#new_form_field", as: :new_form_field
  post '/projects/:project_apikey/:form_apikey/new-form-field', to: "custom_forms#create_form_field", as: :create_form_field
  get  '/projects/:project_apikey/:form_apikey/:form_field_apikey/edit', to: "custom_forms#edit_form_field", as: :edit_form_field
  post '/projects/:project_apikey/:form_apikey/:form_field_apikey/edit', to: "custom_forms#update_form_field", as: :update_form_field

  # FORM SUBMISSIONS
  get '/projects/:project_apikey/:form_apikey/submission/:form_submission_apikey', to: "custom_forms#show_form_submission", as: :show_form_submission

  namespace :api do
    namespace :v1 do # Optional: API versioning
      get '/hello-world', to: 'custom_forms#hello_world'
      post '/form-submission/:form_apikey', to: 'custom_forms#form_submission'
    end
  end
end
