# frozen_string_literal: true

# Matrix Terminal Routes
# Add these to your config/routes.rb inside Rails.application.routes.draw do

# Matrix Terminal Landing Page (Bot Protection)
get 'matrix', to: 'matrix#index', as: :matrix
post 'matrix/pass', to: 'matrix#pass'
