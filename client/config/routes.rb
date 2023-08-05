Rails.application.routes.draw do
  get '/payments_with_quality_check', to: 'payments#with_quality_check'

  root to: redirect('/payments_with_quality_check')
end
