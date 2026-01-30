# frozen_string_literal: true

# Matrix Theme Configuration
# Matrix-style cyberpunk theme for Mastodon

Rails.application.config.to_prepare do
  # Default theme setting
  # Options: 'default', 'matrix', 'light'
  Matrix::THEME = ENV.fetch('MATRIX_THEME', 'matrix').freeze

  # Matrix color variant (admin-configurable during install)
  # Options: 'green', 'red', 'blue', 'purple'
  Matrix::MATRIX_COLOR = ENV.fetch('MATRIX_COLOR', 'green').freeze

  # Validate color
  valid_colors = %w[green red blue purple]
  unless valid_colors.include?(Matrix::MATRIX_COLOR)
    Rails.logger.warn "[Matrix] Invalid MATRIX_COLOR '#{Matrix::MATRIX_COLOR}', defaulting to 'green'"
    Matrix::MATRIX_COLOR = 'green'.freeze
  end

  # Color palette definitions
  Matrix::MATRIX_COLORS = {
    green: {
      name: 'Green',
      description: 'Classic Matrix green',
      primary: '#00ff00',
      dark: '#00cc00',
      rgb: '0, 255, 0'
    },
    red: {
      name: 'Red',
      description: 'Aggressive red Matrix',
      primary: '#ff0000',
      dark: '#cc0000',
      rgb: '255, 0, 0'
    },
    blue: {
      name: 'Blue',
      description: 'Cyber blue Matrix',
      primary: '#00bfff',
      dark: '#0099cc',
      rgb: '0, 191, 255'
    },
    purple: {
      name: 'Purple',
      description: 'Cyberpunk purple Matrix',
      primary: '#bf00ff',
      dark: '#9900cc',
      rgb: '191, 0, 255'
    }
  }.freeze

  # Theme configuration
  Matrix::THEME_CONFIG = {
    matrix: {
      name: 'Matrix',
      description: 'Cyberpunk hacker style with customizable color',
      body_class: 'theme-matrix',
      colors: Matrix::MATRIX_COLORS[Matrix::MATRIX_COLOR.to_sym] || Matrix::MATRIX_COLORS[:green]
    },
    default: {
      name: 'Default',
      description: 'Standard Mastodon dark theme',
      body_class: '',
      colors: {
        primary: '#6364ff',
        background: '#191b22',
        text: '#ffffff'
      }
    },
    light: {
      name: 'Light',
      description: 'Light mode theme',
      body_class: 'theme-mastodon-light',
      colors: {
        primary: '#6364ff',
        background: '#ffffff',
        text: '#000000'
      }
    }
  }.freeze

  Rails.logger.info "[Matrix] Theme: #{Matrix::THEME}, Color: #{Matrix::MATRIX_COLOR}"
end
